variable "convention" {
  type    = string
  default = "sample-env"
}

variable "security_group_config" {
  type = map(object({
    vpc_id   = string
    vpc_cidr = string
  }))
  # For exmaple
  default = {
    ap-northeast-2 = {
      vpc_id   = ""
      vpc_cidr = ""
    }
    us-west-2 = {
      vpc_id   = ""
      vpc_cidr = ""
    }
  }
}
