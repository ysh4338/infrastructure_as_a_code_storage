module "security_group_vpc_endpoint_ap_northeast_2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.0.0"

  name        = local.security_group_setting.vpc_endpoint.ap-northeast-2.name
  vpc_id      = local.vpc_id_ap
  description = "Security group for vpc endpoint"

  ingress_with_cidr_blocks = local.security_group_setting.vpc_endpoint.ap-northeast-2.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}

module "security_group_vpc_endpoint_us_west_2" {
  providers = {
    aws          = aws.oregon
  }
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.0.0"

  name        = local.security_group_setting.vpc_endpoint.us-west-2.name
  vpc_id      = local.vpc_id_us
  description = "Security group for vpc endpoint"

  ingress_with_cidr_blocks = local.security_group_setting.vpc_endpoint.us-west-2.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}

module "security_group_ec2_eks_bastion" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.0.0"

  name        = local.security_group_setting.ec2-instance.eks_bastion.name
  vpc_id      = local.vpc_id_ap
  description = "Security group for ec2"

  ingress_with_cidr_blocks = local.security_group_setting.ec2-instance.eks_bastion.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}

module "security_group_ec2_app_server" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.0.0"

  name        = local.security_group_setting.ec2-instance.app_server.name
  vpc_id      = local.vpc_id_ap
  description = "Security group for ec2"

  ingress_with_cidr_blocks = local.security_group_setting.ec2-instance.app_server.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}

module "security_group_rds_aurora" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.0.0"

  name        = local.security_group_setting.rds.aurora_postgresql.name
  vpc_id      = local.vpc_id_ap
  description = "Security group for aurora postgresql"

  ingress_with_cidr_blocks = local.security_group_setting.rds.aurora_postgresql.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}

module "security_group_alb" {
  source    = "terraform-aws-modules/security-group/aws"
  version   = "5.0.0"

  name        = local.security_group_setting.elb.application.name
  vpc_id      = local.vpc_id_ap
  description = "Security group for alb"

  ingress_with_cidr_blocks = local.security_group_setting.elb.application.ingress_rule
  egress_rules             = local.security_group_setting.common_egress_rule
}