# AWS region
variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
}

# CIDR block for the VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

# Public subnet CIDR blocks
variable "public_subnet_1" {
  description = "CIDR block for the first public subnet."
  type        = string
}

variable "public_subnet_2" {
  description = "CIDR block for the second public subnet."
  type        = string
}

# Private subnet CIDR blocks
variable "private_subnet_1" {
  description = "CIDR block for the first private subnet."
  type        = string
}

variable "private_subnet_2" {
  description = "CIDR block for the second private subnet."
  type        = string
}

# Availability zones
variable "availability_zone_1" {
  description = "The availability zone for the first public and private subnet."
  type        = string
}

variable "availability_zone_2" {
  description = "The availability zone for the second public and private subnet."
  type        = string
}

# Project name
variable "project_name" {
  description = "The name of the project."
  type        = string
}

# Environment
variable "environment" {
  description = "The environment the infrastructure is being deployed in."
  type        = string
}



variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "aws_access_key_id" {
  description = "access key of aws"
  type        = string
}

variable "aws_secret_access_key" {
  description = "secrete key of aws"
  type        = string
}

variable "aws_region" {
  description = "Name of region"
  type        = string
}
