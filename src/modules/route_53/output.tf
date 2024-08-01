output "route53_information" {
  value = {
    for k, v in aws_route53_zone.this : k => {
      # length(v.dns_entry) > 0 조건문을 통해 빈 값인 경우 null 값 반영
      arn        = length(v.arn) > 0 ? v.arn : null
    }
  }
}