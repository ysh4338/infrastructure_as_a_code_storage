variable "key_pair_config" {
  description = "Configuration for EC2 key pairs"
  type = map(object({
    key_name           = string
    create_private_key = string
    save_path_pem      = string
    pem_key_permission = string
  }))
}
