variable "route53_zone_config" {
  type = map(object({
    name = string
    region = string
    vpc_id = string
    name_zone = object({
      name = string
      zone_id = string
    })
  }))
}
