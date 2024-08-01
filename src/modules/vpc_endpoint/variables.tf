variable "vpc_endpoint_configs" {
  type = object({
    region                = string
    vpc_id                = string
    endpoints             = map(object({
      service             = string
      subnet_ids          = list(string)
      security_group_ids  = list(string)
      private_dns_enabled = bool
      tags                = map(string)
    }))
  })
  # # example
  # default = {
  #   region               = "ap-northeast-2"
  #   vpc_id               = "vpc-0123456789abcdef"
  #   endpoints            = {
  #     "s3" = {
  #       service             = "s3"
  #       subnet_ids          = ["subnet-0123456789abcdef", "subnet-fedcba9876543210"]
  #       security_group_ids  = ["sg-0123456789abcdef", "sg-fedcba9876543210"]
  #       private_dns_enabled = null
  #       tags                = {"Owner" = "Data Team"}
  #     }
  #   }
  # }
}
