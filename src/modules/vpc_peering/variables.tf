variable "vpc_configs" {
  description = "A map of VPC configurations"
  type = map(object({
    region       = string
    vpc_id       = string
    account_id   = string
    peering_name = string
    peer_vpc_cidr = string
    route_table_ids = list(string)
  }))
  # example
  default = {
    ap-northeast-2 = {
      region       = "ap-northeast-2"
      vpc_id       = ""
      account_id   = ""
      peering_name = ""
      peer_vpc_cidr = ""
      route_table_ids = []
    },
    us-west-2 = {
      region       = "us-west-2"
      vpc_id       = ""
      account_id   = ""
      peering_name = ""
      peer_vpc_cidr = ""
      route_table_ids = []
    }
  }
}
