resource "aws_security_group" "efs" {
  vpc_id = aws_vpc.main.id

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = [aws_vpc.main.cidr_block]
      description      = ""
      from_port        = 2049
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 2049
    }
  ]
}

resource "aws_efs_file_system" "main" {
  encrypted  = true
  kms_key_id = aws_kms_key.main.arn

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "main" {
  count = length(aws_subnet.main)

  file_system_id  = aws_efs_file_system.main.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = aws_subnet.main[count.index].id
}
