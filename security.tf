resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "EKS Worker Node Security Group"
  vpc_id      = aws_vpc.eks_vpc.id

 # Allow all outbound traffic (needed for node communication)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow nodes to communicate within the security group
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_worker_sg.id]
  }

  # Allow communication from worker nodes to control plane
  ingress {
    description = "Allow worker nodes to communicate with EKS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_control_plane_sg.id]
  }

    # 允许集群内部组件互通（Node <-> Master）
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # CoreDNS 需要 DNS 解析端口 53
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    self        = true
  }

}


resource "aws_security_group" "eks_control_plane_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  description = "EKS Control Plane Security Group"
  name   = "eks-cluster-sg"

  # 允许 Worker Node 访问 EKS API Server
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 允许集群内部组件互通（Node <-> Master）
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # CoreDNS 需要 DNS 解析端口 53
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    self        = true
  }

  # 允许 EKS 控制平面与 Worker Node 之间通信
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}