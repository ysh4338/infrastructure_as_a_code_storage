# vpc endpoint security group info
output "ap_northeast_2_vpc_endpoint_security_group_id" {
  value = module.security_group_vpc_endpoint_ap_northeast_2.security_group_id
}
output "us_west_2_vpc_endpoint_security_group_id" {
  value = module.security_group_vpc_endpoint_us_west_2.security_group_id
}

# ec2 server info
output "ap_northeast_2_ec2_eks_bastion_security_group_id" {
  value = module.security_group_ec2_eks_bastion.security_group_id
}
output "ap_northeast_2_ec2_app_server_security_group_id" {
  value = module.security_group_ec2_app_server.security_group_id
}

# database info
output "ap_northeast_2_rds_aurora_postgresql_security_group_id" {
  value = module.security_group_rds_aurora.security_group_id
}

# load balancer info
output "ap_northeast_2_alb_security_group_id" {
  value = module.security_group_alb.security_group_id
}