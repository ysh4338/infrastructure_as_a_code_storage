output "iam_instance_profile_name_ec2" {
  description = "The name of the IAM instance profile for ec2."
  value       = module.iam_role_ec2.iam_instance_profile_name
}
