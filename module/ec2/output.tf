output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "key_name" {
  description = "The name of the key pair used for the EC2 instance"
  value       = aws_key_pair.key.key_name
}

output "private_key" {
  description = "The private key for SSH access"
  value       = tls_private_key.key.private_key_pem
  sensitive   = true
}



