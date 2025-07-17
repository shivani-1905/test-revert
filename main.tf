module "vpc" {
  source = "./module/vpc"  # Adjust the path to your VPC module

  cidr_block          = var.cidr_block
  public_subnet_1    = var.public_subnet_1
  public_subnet_2    = var.public_subnet_2
  private_subnet_1   = var.private_subnet_1
  private_subnet_2   = var.private_subnet_2
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
  project_name       = var.project_name
  environment        = var.environment

}


module "ec2" {
  source = "./module/ec2"  # Path to your EC2 module

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  instance_name      = var.instance_name
  aws_access_key_id = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_region = var.aws_region

 
}
