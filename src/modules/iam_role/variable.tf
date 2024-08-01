variable "iam_role_config" {
  description = "Configuration for IAM roles"
  type = map(object({
    role_name               = string
    role_requires_mfa       = bool
    create_role             = bool
    create_instance_profile = bool
    attach_poweruser_policy = bool
    attach_admin_policy     = bool
    trusted_role_actions    = list(string)
    trusted_role_services   = list(string)
    custom_role_policy_arns = list(string)
  }))
}
