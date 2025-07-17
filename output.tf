# Output the ID of the Internet Gateway
output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
  description = "The ID of the Internet Gateway from the VPC module."
}

# Output the ID of the NAT Gateway
output "nat_gateway_id" {
  value       = module.vpc.nat_gateway_id
  description = "The ID of the NAT Gateway from the VPC module."
}

# Output the names of the private subnets
output "private_subnet_1_name" {
  value =  module.vpc.private_subnet_1_name
  description = "The names of the private subnets from the VPC module."
}

# Output the IDs of the private subnets
output "private_subnet_1_id" {
  value       = module.vpc.private_subnet_1_id
  description = "The IDs of the private subnets from the VPC module."
}

# Output the names of the private subnets
output "private_subnet_2_name" {
  value = module.vpc.private_subnet_2_name
  description = "The names of the private subnets from the VPC module."
}

# Output the IDs of the private subnets
output "private_subnet_2_id" {
  value       = module.vpc.private_subnet_2_id
  description = "The IDs of the private subnets from the VPC module."
}

# Output the names of the public subnets
output "public_subnet_1_name" {
  value       = module.vpc.public_subnet_1_id
  description = "The names of the public subnets from the VPC module."
}


# Output the IDs of the public subnets
output "public_subnet_1_id" {
  value       = module.vpc.public_subnet_1_id
  description = "The IDs of the public subnets from the VPC module."
}

# Output the names of the public subnets
output "public_subnet_2_name" {
  value       = module.vpc.public_subnet_2_id
  description = "The names of the public subnets from the VPC module."
} 


output "public_subnet_2_id" {
  value       = module.vpc.public_subnet_2_id
  description = "The IDs of the public subnets from the VPC module."
}



# Output the ID of the VPC
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC from the VPC module."
}

# Output the name of the VPC
output "vpc_name" {
  value       = module.vpc.vpc_name
  description = "The name of the VPC from the VPC module."
}


output "ec2_key_pair_name" {
  description = "The key pair name used for the EC2 instance"
  value       = module.ec2.key_name  # Correct reference to key_name
}

output "ec2_private_key" {
  description = "The private key for SSH access to the EC2 instance"
  value       = module.ec2.private_key  # Correct reference to private_key
  sensitive   = true
}



