# Generate a new SSH key pair
resource "tls_private_key" "eks_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the generated public key
resource "aws_key_pair" "eks_key_pair" {
  key_name   = "my-eks-key"  # Change this to your preferred key name
  public_key = tls_private_key.eks_key.public_key_openssh

  tags = {
    Name = "EKS Key Pair"
  }
}


resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-group-role-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = ["ec2.amazonaws.com",
                    "eks.amazonaws.com"]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}


resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "minimal-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_subnet_1.id,
                     aws_subnet.private_subnet_2.id]
  
  ami_type = "AL2_x86_64"
  instance_types =["t3.medium"]

  remote_access {
    ec2_ssh_key = aws_key_pair.eks_key_pair.key_name  # sshKey in remote-access can't be empty
    source_security_group_ids = [aws_security_group.eks_worker_sg.id] 
  }
  
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  #the default fail join time is 30mins, take too long to throw exception
  timeouts {
    create = "10m"
    delete = "7m"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly_policy
  ]
}

data "kubernetes_config_map" "existing_aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  
  depends_on = [aws_eks_node_group.node_group,
                data.aws_eks_cluster.cluster,
                data.aws_eks_cluster_auth.cluster_auth ]

}


resource "kubernetes_config_map" "aws_auth" {
  depends_on = [aws_eks_node_group.node_group,
                data.aws_eks_cluster.cluster,
                data.aws_eks_cluster_auth.cluster_auth ]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles" = yamlencode(
      concat(
        try(yamldecode(data.kubernetes_config_map.existing_aws_auth.data["mapRoles"]), []),
        [
          {
            rolearn  = aws_iam_role.eks_node_role.arn
            username = "system:node:{{EC2PrivateDNSName}}"
            groups   = ["system:bootstrappers", "system:nodes"]
          }
    ]))
  }
}