locals {
  gateway_services = ["s3", "dynamodb"]
}

resource "aws_vpc_endpoint" "this" {
  for_each = var.vpc_endpoint_configs.endpoints

  vpc_id              = var.vpc_endpoint_configs.vpc_id
  service_name        = "com.amazonaws.${var.vpc_endpoint_configs.region}.${each.value.service}"
  vpc_endpoint_type   = contains(local.gateway_services, each.key) ? "Gateway" : "Interface"
  subnet_ids          = each.value.subnet_ids
  security_group_ids  = each.value.security_group_ids
  private_dns_enabled = each.value.private_dns_enabled

  tags = merge(
    each.value.tags,
    {
      Name = "${var.vpc_endpoint_configs.convention}-vpc-endpoint-${each.key}"
    }
  )
}
