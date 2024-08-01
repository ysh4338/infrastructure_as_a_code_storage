# route 53 private hosted zone setting
# for_each = var.route53_zone_config
resource "aws_route53_zone" "this" {
  for_each = var.route53_zone_config
  name = "${each.value.name}.${each.value.region}.amazonaws.com"

  vpc {
    vpc_id = each.value.vpc_id
  }
}
resource "aws_route53_record" "this" {
  for_each = var.route53_zone_config
  zone_id = aws_route53_zone.this[each.key].zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = each.value.name_zone.name
    zone_id                = each.value.name_zone.zone_id
    evaluate_target_health = true
  }
}