variable "ec2_config" {
  description = "Configuration for EC2 instances"
  type = map(object({
    ami                    = string
    key_name               = string
    instance_type          = string
    subnet_id              = string
    vpc_security_group_ids = list(string)
    tag_name               = string
  }))
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for the EC2 instances"
  type        = string
}
