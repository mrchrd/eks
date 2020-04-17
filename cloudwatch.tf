resource "aws_cloudwatch_log_group" "cluster" {
  kms_key_id        = aws_kms_key.main.arn
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = local.log_retention
}

resource "aws_cloudwatch_log_group" "application" {
  kms_key_id        = aws_kms_key.main.arn
  name              = "/aws/containerinsights/${local.cluster_name}/application"
  retention_in_days = local.log_retention
}

resource "aws_cloudwatch_log_group" "dataplane" {
  kms_key_id        = aws_kms_key.main.arn
  name              = "/aws/containerinsights/${local.cluster_name}/dataplane"
  retention_in_days = local.log_retention
}

resource "aws_cloudwatch_log_group" "host" {
  kms_key_id        = aws_kms_key.main.arn
  name              = "/aws/containerinsights/${local.cluster_name}/host"
  retention_in_days = local.log_retention
}

resource "aws_cloudwatch_log_group" "performance" {
  kms_key_id        = aws_kms_key.main.arn
  name              = "/aws/containerinsights/${local.cluster_name}/performance"
  retention_in_days = local.log_retention
}
