module "ec2_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = var.key_name
  create_private_key = var.create_private_key
}

resource "local_file" "test_local" {
  filename        = var.save_path_pem
  file_permission = var.pem_key_permission
  content         = module.ec2_key_pair.private_key_pem
}