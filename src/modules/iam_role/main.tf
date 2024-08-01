module "iam_role_ec2" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name         = var.iam_role_config["ec2"].role_name
  role_requires_mfa = var.iam_role_config["ec2"].role_requires_mfa

  create_role             = var.iam_role_config["ec2"].create_role
  create_instance_profile = var.iam_role_config["ec2"].create_instance_profile
  attach_poweruser_policy = var.iam_role_config["ec2"].attach_poweruser_policy
  attach_admin_policy     = var.iam_role_config["ec2"].attach_admin_policy
  custom_role_policy_arns = var.iam_role_config["ec2"].custom_role_policy_arns

  trusted_role_actions  = var.iam_role_config["ec2"].trusted_role_actions
  trusted_role_services = var.iam_role_config["ec2"].trusted_role_services
}
