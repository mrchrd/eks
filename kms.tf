resource "aws_kms_key" "main" {
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ca-central-1.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_grant" "eks_workers" {
  count = length(aws_eks_node_group.main)

  grantee_principal = aws_eks_node_group.main[count.index].node_role_arn
  key_id            = aws_kms_key.main.key_id

  operations = [
    "CreateGrant",
    "Decrypt",
    "DescribeKey",
    "Encrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
  ]
}

output "kms_key_arn" {
  value = aws_kms_key.main.arn
}
