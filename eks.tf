
resource "aws_iam_role" "node_role" {
    name = "eks-node-group-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Action: "sts:AssumeRole"
        }]
    })

}

resource "aws_iam_role_policy_attachment" "node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "minimal-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet.id]
  }
}
   