#vpc variable value
# AWS Region
region              = "us-west-2"

# CIDR block for the VPC
cidr_block          = "10.0.0.0/16"

# Public subnet CIDR blocks
public_subnet_1    = "10.0.1.0/24"
public_subnet_2    = "10.0.2.0/24"

# Private subnet CIDR blocks
private_subnet_1   = "10.0.3.0/24"
private_subnet_2   = "10.0.4.0/24"

# Availability zones
availability_zone_1 = "us-west-2a"
availability_zone_2 = "us-west-2b"

# Project name
project_name       = "my_project"

# Environment
environment        = "dev"


instance_name = "MyEC2Instance"  # Name of the EC2 instance
ami_id             = "ami-0a0e5d9c7acc336f1"  # Replace with your actual AMI ID
instance_type      = "t2.medium"                # Example instance type          # Instance name
aws_access_key_id = "xxxxxxxxxxx"
aws_secret_access_key = "xxxxxxxxxx"
aws_region = "ap-south-1"

