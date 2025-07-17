#!/bin/bash

set -e

echo "Starting the script..."

# Function to install AWS CLI
install_aws_cli() {
    echo "Installing AWS CLI..."
    
    # Update the package index
    sudo apt update -y
    
    # Install AWS CLI
    sudo apt install awscli -y
    
    # Verify installation
    aws --version
    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
    
    
    # Configure AWS CLI
    aws configure --profile shiva
    aws sts get-caller-identity
    aws configure list-profiles
    export AWS_DEFAULT_PROFILE=shiva
    echo "AWS CLI installed and configured."
}





# Function to install kubectl
# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    
    # Download the latest stable version of kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    
    # Make the kubectl binary executable
    chmod +x kubectl
    
    # Move the binary to a directory in your PATH
    sudo mv kubectl /usr/local/bin/kubectl
    
    # Verify that kubectl was installed
    if kubectl version --client; then
        echo "kubectl installed successfully."
    else
        echo "kubectl installation failed."
        exit 1
    fi
}


# Function to install eksctl
# Function to install eksctl
install_eksctl() {
    echo "Installing eksctl..."
    
    # Download eksctl from the latest release
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" -o eksctl.tar.gz
    
    # Extract the tar file
    tar xz -C /tmp -f eksctl.tar.gz
    
    # Move eksctl to a directory in your PATH
    sudo mv /tmp/eksctl /usr/local/bin/eksctl
    
    # Verify installation
    if eksctl version; then
        echo "eksctl installed successfully."
    else
        echo "eksctl installation failed."
        exit 1
    fi
}


# Function to install Docker
# Function to install Docker
install_docker() {
    echo "Installing Docker..."

    # Update the package index
    if ! sudo apt-get update -y; then
        echo "Failed to update package index."
        exit 1
    fi

    # Install required packages
    if ! sudo apt-get install -y ca-certificates curl gnupg; then
        echo "Failed to install prerequisites for Docker."
        exit 1
    fi

    # Set up the Docker repository
    if ! sudo install -m 0755 -d /etc/apt/keyrings; then
        echo "Failed to create directory for keyrings."
        exit 1
    fi

    if ! curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then
        echo "Failed to add Docker's GPG key."
        exit 1
    fi

    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index again
    if ! sudo apt-get update -y; then
        echo "Failed to update package index after adding Docker's repository."
        exit 1
    fi

    # Install Docker
    if ! sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
        echo "Docker installation failed."
        exit 1
    fi

    # Add user to the Docker group
    if ! sudo usermod -aG docker ${USER}; then
        echo "Failed to add user to Docker group."
        exit 1
    fi

    echo "Docker installed successfully."
}


# Function to configure AWS EKS and create namespace
configure_eks() {
    echo "Configuring EKS..."
    aws eks update-kubeconfig --name My-cluster --region ap-south-1
    kubectl create namespace nsp
    kubectl config set-context --current --namespace=nsp
    echo "EKS configured."
}

# Function to install ALB controller and create IAM policy
install_alb_controller() {
    echo "Installing ALB controller..."
    curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

    aws iam create-policy \
        --policy-name AWSLoadBalancerControllerIAMPolicy \
        --policy-document file://iam_policy.json

    oidc_id=$(aws eks describe-cluster --name My-cluster --region ap-south-1 --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
    aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

    cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<account-id>:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/$oidc_id"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.ap-south-1.amazonaws.com/id/$oidc_id:aud": "sts.amazonaws.com",
                    "oidc.eks.ap-south-1.amazonaws.com/id/$oidc_id:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

    aws iam create-role \
      --role-name AmazonEKSLoadBalancerControllerRole \
      --assume-role-policy-document file://"load-balancer-role-trust-policy.json"

    aws iam attach-role-policy \
        --policy-arn arn:aws:iam::<account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
        --role-name AmazonEKSLoadBalancerControllerRole

    cat >aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
    labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/name: aws-load-balancer-controller
    name: aws-load-balancer-controller
    namespace: kube-system
    annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/AmazonEKSLoadBalancerControllerRole
EOF

    kubectl apply -f aws-load-balancer-controller-service-account.yaml
    echo "ALB controller installed."
}

# Function to install Helm
install_helm() {
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh

    helm repo add eks https://aws.github.io/eks-charts
    helm repo update eks

    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
      -n kube-system \
      --set clusterName=test \
      --set serviceAccount.create=false \
      --set serviceAccount.name=aws-load-balancer-controller 
    echo "Helm installed."
}

# Function to create Application Load Balancer
create_alb() {
    echo "Creating Application Load Balancer..."
    export VPC_ID=vpc-027c292bbb73860f6
    export PUB_SUBNET_IDS=('subnet-071af04ee11cc21fd' 'subnet-0a4e5927888e57c40')

    ALB_ARN=$(aws elbv2 create-load-balancer \
      --name test-alb \
      --type application \
      --subnets "${PUB_SUBNET_IDS[@]}" \
      --query 'LoadBalancers[].LoadBalancerArn' \
      --output text)

    for tg in tg1 tg2; do
        RED_TG=$(aws elbv2 create-target-group \
          --name $tg \
          --port 80 \
          --protocol HTTP \
          --target-type ip \
          --vpc-id $VPC_ID \
          --query 'TargetGroups[].TargetGroupArn' \
          --output text)
    done
    echo "Application Load Balancer created."
}

# Function to create ECR and login
create_ecr_and_login() {
    echo "Creating ECR repositories and logging in..."
    for repo in tgb-v1-api-service tgb-v1-crm-service tgb-v1-ingestion-service tgb-v1-questionaire; do
        aws ecr create-repository --repository-name $repo --region ap-south-1 || true
        aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 231046994435.dkr.ecr.ap-south-1.amazonaws.com/$repo
    done
    echo "ECR repositories created and logged in."
}

# Main script execution
install_aws_cli
install_kubectl
install_eksctl
install_docker
configure_eks
install_alb_controller
install_helm
create_alb
create_ecr_and_login

echo "All installations and configurations are complete."
