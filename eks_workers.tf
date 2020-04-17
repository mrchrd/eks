resource "aws_eks_node_group" "main" {
  count = length(aws_subnet.main)

  ami_type        = "AL2_x86_64"
  cluster_name    = aws_eks_cluster.main.name
  instance_types  = local.instance_types
  node_group_name = "${local.cluster_name}_main_${count.index}"
  node_role_arn   = aws_iam_role.main.arn
  subnet_ids      = [aws_subnet.main[count.index].id]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  tags = {
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.main.name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                      = "true"
  }
}

/*
resource "aws_eks_node_group" "gpu" {
  count = length(aws_subnet.main)

  ami_type        = "AL2_x86_64_GPU"
  cluster_name    = aws_eks_cluster.main.name
  instance_types  = ["g4dn.xlarge"]
  node_group_name = "${local.cluster_name}_gpu_${count.index}"
  node_role_arn   = aws_iam_role.main.arn
  subnet_ids      = [aws_subnet.main[count.index].id]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  tags = {
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.main.name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                      = "true"
  }
}
*/
