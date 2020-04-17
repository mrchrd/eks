resource "random_pet" "cluster" {
  separator = ""
}

locals {
  aws_region         = var.aws_region
  cluster_name       = coalesce(var.cluster_name, random_pet.cluster.id)
  cluster_version    = var.cluster_version
  instance_types     = [var.instance_type]
  log_retention      = var.log_retention
  policy_assumerole  = file("${path.module}/assets/assumerole-policy.json")
  policy_autoscaling = file("${path.module}/assets/autoscaling-policy.json")
  policy_cloudwatch  = file("${path.module}/assets/cloudwatch-policy.json")
}

output "aws_region" {
  value = local.aws_region
}
