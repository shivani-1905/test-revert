# Create a new key pair
resource "aws_key_pair" "key" {
  key_name   = "eks-key"
  public_key = tls_private_key.key.public_key_openssh
}

# Generate a new private key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 instance
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key.key_name  # Reference the correct key_name attribute
  vpc_security_group_ids       = [aws_security_group.example_sg.id]
  associate_public_ip_address  = true
  tags = {
    Name = var.instance_name
  }

  # Use the file provisioner to copy the script
  provisioner "file" {
    source      = "C:/Users/Admin/Desktop/Ec2-eks-manager/module/ec2/ekssetup.sh"
    destination = "/tmp/ekssetup.sh"
    connection {
      type     = "ssh"
      user     = "ubuntu" # Change to the appropriate user for your AMI
      private_key = tls_private_key.key.private_key_openssh # Ensure you have the private key available
      host     = self.public_ip
    }
  }

  # Use the remote-exec provisioner to run the script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ekssetup.sh",
      "bash /tmp/ekssetup.sh",
      "export AWS_ACCESS_KEY_ID='${var.aws_access_key_id}'",
      "export AWS_SECRET_ACCESS_KEY='${var.aws_secret_access_key}'",
      "export AWS_DEFAULT_REGION='${var.aws_region}'",
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu" # Change to the appropriate user for your AMI
      private_key = tls_private_key.key.private_key_openssh # Ensure you have the private key available
      host     = self.public_ip
    }
  }
}
