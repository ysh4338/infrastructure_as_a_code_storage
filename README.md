# Terraform Environment Setting
- Amazon Linux environment setting
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```
- terraform 실행 Command
```bash
terraform init
terraform apply
```
- 생성 후 PEM 키 확인하는 방법 (해당 폴더 내 pem키 저장됨)
```bash
terraform state pull | jq -r '.resources[] | select(.type == "tls_private_key") | .instances[0].attributes.private_key_pem'
```

# output 값 확인하는 방법
1. **output** 파일에서 다중 값들이 반환되는 경우 확인하는 방법
``` bash
output "vpc_endpoints_information" {
  value = {
    for k, v in aws_vpc_endpoint.this : k => {
      dns_name        = length(v.dns_entry) > 0 ? v.dns_entry[0].dns_name : null
      hosted_zone_id  = length(v.dns_entry) > 0 ? v.dns_entry[0].hosted_zone_id : null
    }
  }
}
```

2. **output** 파일 추가
```bash
output "vpc_endpoints_information_keys" {
  value = keys(module.vpc_endpoints_us_west_2.vpc_endpoints_information)
}
```

3. terraform apply 실행 후 반환되는 모듈의 키 값 확인
```bash
terraform apply
...
Outputs:
vpc_endpoints_information_keys = [
  "bedrock",
  "bedrock-runtime",
  "s3",
  "sts",
]
```

4. **terraform console**로 접속해서 모듈의 키 값을 이용해서 아웃풋 값 확인
```bash
terraform console
module.vpc_endpoints_us_west_2.vpc_endpoints_information["bedrock-runtime"]
{
  "dns_name" = "vpce-0c42d9c1316326bbd-a0hag00y.bedrock-runtime.us-west-2.vpce.amazonaws.com"
  "hosted_zone_id" = "Z1YSA3EXCYUU9Z"
}
```

**※ for_each & this** 문법을 이용해서 리소스를 생성할 때 다중리전에서 겹치는 리소스가 있는 경우  주의점
- 모듈을 리전별로 다르게 호출하는 것이 좋다.
- 생성된 값들을 output 파일로 출력했을 때 각각의 리소스를 구분해서 다른 모듈에 적용하기 위해서 필요함
- vpc endpoint의 경우 모듈을 ap_northeast_2와 us_west_2로 구분해서 생성하였음
- 다른 모듈에서 호출할 때는 아래 예시와 같이 호출해야 함.
```bash
terraform console
> module.vpc_endpoints_ap_northeast_2.vpc_endpoints_information["sts"]
{
  "dns_name" = "vpce-01c0afa89dca976b5-c06ml6bf.sts.ap-northeast-2.vpce.amazonaws.com"
  "hosted_zone_id" = "Z27UANNT0PRK1T"
}
> module.vpc_endpoints_us_west_2.vpc_endpoints_information["sts"]
{
  "dns_name" = "vpce-0ee8eab2828112331-699fl67q.sts.us-west-2.vpce.amazonaws.com"
  "hosted_zone_id" = "Z1YSA3EXCYUU9Z"
}
```


# Terraform Reference
***Skill Reference URL***
- https://hands-on.cloud/vpc-endpoint-cross-region-terraform/
- https://github.com/cm-ishizawa-takuya/resource_cetralized/blob/vpce_centralized/variables.tf
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.0.0?tab=inputs
- https://github.com/terraform-aws-modules/terraform-aws-vpc
- https://registry.terraform.io/search/modules?namespace=terraform-aws-modules&provider=aws

***Terraform BP Reference***
- https://www.terraform-best-practices.com/
- https://helloworld.kurly.com/blog/terraform-adventure/#terraform-%EA%B5%AC%EC%A1%B0%EB%A5%BC-%EC%96%B4%EB%96%BB%EA%B2%8C-%EA%B5%AC%EC%84%B1%ED%95%A0%EA%B9%8C

***EKS 생성 시 권한 비활성화***
- https://malwareanalysis.tistory.com/728