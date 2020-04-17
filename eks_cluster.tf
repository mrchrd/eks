resource "aws_iam_role" "eks_cluster" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "main" {
  depends_on = [
    aws_cloudwatch_log_group.cluster,
    aws_cloudwatch_log_group.application,
    aws_cloudwatch_log_group.dataplane,
    aws_cloudwatch_log_group.host,
    aws_cloudwatch_log_group.performance,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]

  name     = local.cluster_name
  role_arn = aws_iam_role.main.arn
  version  = local.cluster_version

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = aws_kms_key.main.arn
    }
  }

  vpc_config {
    subnet_ids = aws_subnet.main.*.id
  }
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}
