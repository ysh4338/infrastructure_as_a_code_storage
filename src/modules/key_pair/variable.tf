variable "key_name" {
  description = "The name for the key pair. Conflicts with `key_name_prefix`"
  type        = string
  default     = null
}

variable "create_private_key" {
  description = "Determines whether a private key will be created"
  type        = bool
  default     = false
}

variable "save_path_pem" {
  description = "Specify key file storage path"
  type        = string
  default     = null    # "./keypair/test-keypair.pem"
}

variable "pem_key_permission" {
  description = "Specify key file storage path"
  type        = string
  default     = null    # "0600"
}