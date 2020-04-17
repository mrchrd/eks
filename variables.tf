variable "aws_region" {
  default = "ca-central-1"
}

variable "cluster_name" {
  default = ""
}

variable "cluster_version" {
  default = "1.15"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "log_retention" {
  default = 7
}
