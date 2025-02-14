#add IAM full access to my IAM role to create the eks_role
#create custom eks full access policy
resource "aws_iam_role" "eks_role" {
    name = "eks-cluster-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = ["ec2.amazonaws.com",
                            "eks.amazonaws.com"]
            }
            Action: "sts:AssumeRole"
        }]
    })

}

resource "aws_iam_role_policy_attachment" "eks_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "minimal-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet_1.id,
                  aws_subnet.eks_subnet_2.id
                ]
  }
  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}
   