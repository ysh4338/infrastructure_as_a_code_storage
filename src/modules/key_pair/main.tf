module "ec2_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  for_each           = var.key_pair_config
  key_name           = each.value.key_name
  create_private_key = each.value.create_private_key
}

resource "local_file" "test_local" {
  for_each        = var.key_pair_config
  filename        = each.value.save_path_pem
  file_permission = each.value.pem_key_permission
  content         = module.ec2_key_pair[each.key].private_key_pem
}
