module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  for_each = var.ec2_config

  ami                    = each.value.ami
  key_name               = each.value.key_name
  subnet_id              = each.value.subnet_id
  instance_type          = each.value.instance_type
  vpc_security_group_ids = each.value.vpc_security_group_ids

  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = each.value.tag_name
  }
}
