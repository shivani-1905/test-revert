# Output the ID of the Internet Gateway
output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway."
}

# Output the ID of the NAT Gateway
output "nat_gateway_id" {
  value       = aws_nat_gateway.nat.id
  description = "The ID of the NAT Gateway."
}

# Output the names of the private subnets
output "private_subnet_1_name" {
  value = aws_subnet.private_1.tags["Name"]
  description = "The names of the private subnets."
}

# Output the IDs of the private subnets
output "private_subnet_1_id" {
  value = aws_subnet.private_1.id
  description = "The IDs of the private subnets."
}

output "private_subnet_2_name" {
  value = aws_subnet.private_2.tags["Name"]
  description = "The names of the private subnets."
}

# Output the IDs of the private subnets
output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
  description = "The IDs of the private subnets."
}

# Output the names of the public subnets
output "public_subnet_1_name" {
  value = aws_subnet.public_1.tags["Name"]
  description = "The names of the public subnets."
}

# Output the IDs of the public subnets
output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
  description = "The IDs of the public subnets."
}

output "public_subnet_2_name" {
  value = aws_subnet.public_2.tags["Name"]
  description = "The names of the public subnets."
}

# Output the IDs of the public subnets
output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
  description = "The IDs of the public subnets."
}

# Output the ID of the VPC
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

# Output the name of the VPC
output "vpc_name" {
  value       = aws_vpc.main.tags["Name"]
  description = "The name of the VPC."
}
