output "vpc_endpoints_information_keys" {
  value = keys(module.vpc_endpoints_us_west_2.vpc_endpoints_information)
}

output "route53_information_keys" {
  value = keys(module.route_53.route53_information)
}