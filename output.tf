output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  description = "Public Subnets"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnets" {
  description = "Private Subnets"
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "eks_ctrl_security_group" {
  description = "EKS API server Security Group"
  value       = aws_security_group.eks_control_plane_sg.id
}

output "eks_node_security_group" {
  description = "EKS Node Security Group"
  value       = aws_security_group.eks_worker_sg.id
}