# CIDR block for the VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

# Public subnet 1 CIDR block
variable "public_subnet_1" {
  description = "CIDR block for the first public subnet."
  type        = string
}

# Public subnet 2 CIDR block
variable "public_subnet_2" {
  description = "CIDR block for the second public subnet."
  type        = string
}

# Private subnet 1 CIDR block
variable "private_subnet_1" {
  description = "CIDR block for the first private subnet."
  type        = string
}

# Private subnet 2 CIDR block
variable "private_subnet_2" {
  description = "CIDR block for the second private subnet."
  type        = string
}

# Availability zone for the first public and private subnets
variable "availability_zone_1" {
  description = "The availability zone for the first public and private subnet."
  type        = string
}

# Availability zone for the second public and private subnets
variable "availability_zone_2" {
  description = "The availability zone for the second public and private subnet."
  type        = string
}

# Project name
variable "project_name" {
  description = "The name of the project."
  type        = string
}

# Environment (e.g., dev, staging, prod)
variable "environment" {
  description = "The environment the infrastructure is being deployed in."
  type        = string
}

