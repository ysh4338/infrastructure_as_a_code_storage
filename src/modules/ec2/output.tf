output "ec2_instance_id" {
  description = "The name of the IAM instance profile for ec2."
  value = {
    for k, v in module.ec2_instance : k => {
      instance_id = v.id
    }
  }
}
