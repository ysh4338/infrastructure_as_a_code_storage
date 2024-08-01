output "vpc_endpoints_information" {
  value = {
    # aws_vpc_endpoint 리소스 생성 결과를 k, v에 담아서 아래 코드 쪽으로 k를 전달
    # aws_vpc_endpoint 데이터 형태 예시
    # aws_vpc_endpoint.this = {
    #   "endpoint1" = {
    #     dns_entry = [
    #       {
    #         dns_name = "example1.com"
    #         hosted_zone_id = "ABCDEFG"
    #       }
    #     ]
    #   },
    #   "endpoint2" = {
    #     dns_entry = []
    #   }
    # }
    for k, v in aws_vpc_endpoint.this : k => {
      # length(v.dns_entry) > 0 조건문을 통해 빈 값인 경우 null 값 반영
      dns_name        = length(v.dns_entry) > 0 ? v.dns_entry[0].dns_name : null
      hosted_zone_id  = length(v.dns_entry) > 0 ? v.dns_entry[0].hosted_zone_id : null
    }
  }
}