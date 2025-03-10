data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
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
