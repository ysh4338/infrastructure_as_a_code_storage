# network baseline setting 
module "vpc_ap_northeast_2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  providers = {
    aws = aws
  }

  # vpc setting
  name                    = local.vpc.ap-northeast-2.vpc_name
  cidr                    = local.vpc.ap-northeast-2.vpc_cidr
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  # subnet setting
  azs                   = local.vpc.ap-northeast-2.azs
  public_subnets        = local.vpc.ap-northeast-2.public_subnets
  public_subnet_names   = local.vpc.ap-northeast-2.public_subnet_names
  private_subnets       = local.vpc.ap-northeast-2.private_subnets
  private_subnet_names  = local.vpc.ap-northeast-2.private_subnet_names
  database_subnets      = local.vpc.ap-northeast-2.database_subnets
  database_subnet_names = local.vpc.ap-northeast-2.database_subnet_names

  # nat gateway setting
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # database subnet setting
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_nat_gateway_route      = false
  create_database_internet_gateway_route = false
}
module "vpc_us_west_2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  providers = {
    aws = aws.us-west-2
  }

  # vpc setting
  name                 = local.vpc.us-west-2.vpc_name
  cidr                 = local.vpc.us-west-2.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  # subnet setting
  azs                   = local.vpc.us-west-2.azs
  public_subnets        = local.vpc.us-west-2.public_subnets
  public_subnet_names   = local.vpc.us-west-2.public_subnet_names
  private_subnets       = local.vpc.us-west-2.private_subnets
  private_subnet_names  = local.vpc.us-west-2.private_subnet_names
  database_subnets      = local.vpc.us-west-2.database_subnets
  database_subnet_names = local.vpc.us-west-2.database_subnet_names

  # nat gateway setting
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  # database subnet setting
  create_database_subnet_group           = false
  create_database_subnet_route_table     = false
  create_database_nat_gateway_route      = false
  create_database_internet_gateway_route = false
}

# vpc peering setting
module "vpc_peering" {
  source = "./modules/vpc_peering"
  # version = "5.0.0"
  providers = {
    aws        = aws
    aws.oregon = aws.us-west-2
  }

  vpc_configs = {
    ap-northeast-2 = {
      account_id      = local.account_id
      region          = local.vpc.ap-northeast-2.region
      peering_name    = local.vpc_peering_name
      peer_vpc_cidr   = local.vpc.us-west-2.vpc_cidr
      vpc_id          = module.vpc_ap_northeast_2.vpc_id
      route_table_ids = module.vpc_ap_northeast_2.private_route_table_ids
    }
    us-west-2 = {
      account_id      = local.account_id
      region          = local.vpc.us-west-2.region
      peering_name    = local.vpc_peering_name
      peer_vpc_cidr   = local.vpc.ap-northeast-2.vpc_cidr
      vpc_id          = module.vpc_us_west_2.vpc_id
      route_table_ids = module.vpc_us_west_2.private_route_table_ids
    }
  }
}

# security group setting
module "security_groups" {
  source = "./modules/security_group"

  providers = {
    aws        = aws
    aws.oregon = aws.us-west-2
  }

  convention = local.convention
  security_group_config = {
    ap-northeast-2 = {
      vpc_id   = module.vpc_ap_northeast_2.vpc_id
      vpc_cidr = module.vpc_ap_northeast_2.vpc_cidr_block
    }
    us-west-2 = {
      vpc_id   = module.vpc_us_west_2.vpc_id
      vpc_cidr = module.vpc_us_west_2.vpc_cidr_block
    }
  }
}

# vpc endpoint setting
module "vpc_endpoints_ap_northeast_2" {
  source = "./modules/vpc_endpoint"

  vpc_endpoint_configs = {
    convention = local.enpoints.convention
    region     = local.enpoints.ap-northeast-2.region
    vpc_id     = local.enpoints.ap-northeast-2.vpc_id
    endpoints  = local.enpoints.ap-northeast-2.endpoint
  }
}
module "vpc_endpoints_us_west_2" {
  providers = {
    aws = aws.us-west-2
  }
  source = "./modules/vpc_endpoint"

  vpc_endpoint_configs = {
    convention = local.enpoints.convention
    region     = local.enpoints.us-west-2.region
    vpc_id     = local.enpoints.us-west-2.vpc_id
    endpoints  = local.enpoints.us-west-2.endpoint
  }
}

# ec2 setting
module "key_pair_ap_northeast_2" {
  source = "./modules/key_pair"

  key_pair_config = local.key_pair_config.ap-northeast-2
}
module "key_pair_us_east_2" {
  providers = {
    aws = aws.us-west-2
  }
  source = "./modules/key_pair"

  key_pair_config = local.key_pair_config.us-east-2
}
module "ec2_ap_northeast_2" {
  source = "./modules/ec2"

  ec2_config           = local.ec2_instace_config.ap-northeast-2
  iam_instance_profile = module.iam_role.iam_instance_profile_name_ec2
}
module "iam_role" {
  source = "./modules/iam_role"

  iam_role_config = local.iam_role_config
}

# # aurora setting
# module "rds_aurora_postgresql"{
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   version = "5.0.0"

#   name = local.rds_aurora_config.ap-northeast-2.name

#   username = local.rds_aurora_config.ap-northeast-2.username
#   password = local.rds_aurora_config.ap-northeast-2.password
#   database_name  = local.rds_aurora_config.ap-northeast-2.database_name
#   engine         = local.rds_aurora_config.ap-northeast-2.engine
#   engine_version = local.rds_aurora_config.ap-northeast-2.engine_version
#   instance_type  = local.rds_aurora_config.ap-northeast-2.instance_type
#   storage_encrypted   = true

#   vpc_id  = local.rds_aurora_config.ap-northeast-2.vpc_id
#   db_subnet_group_name = local.rds_aurora_config.ap-northeast-2.db_subnet_group_name

#   vpc_security_group_ids  = local.rds_aurora_config.ap-northeast-2.vpc_security_group_ids

#   tags = { Name = local.rds_aurora_config.ap-northeast-2.tag_name }
# }

# pre-processing data bucket setting
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = local.s3_bucket_config.ap-northeast-2.name

  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning               = { enabled = true }
}

# application load balancer setting (with target group, listeners)
module "alb_ap_northeast_2" {
  source = "terraform-aws-modules/alb/aws"

  name    = local.application_lb_config.ap-northeast-2.name
  vpc_id  = local.application_lb_config.ap-northeast-2.vpc_id
  subnets = local.application_lb_config.ap-northeast-2.subnets

  create_security_group      = local.application_lb_config.ap-northeast-2.create_security_group
  enable_deletion_protection = local.application_lb_config.ap-northeast-2.enable_deletion_protection

  security_groups = local.application_lb_config.ap-northeast-2.security_groups
  listeners       = local.application_lb_config.ap-northeast-2.listeners
  target_groups   = local.application_lb_config.ap-northeast-2.target_groups
  # health_check = local.application_lb_config.ap-northeast-2.health_check
}

module "route_53" {
  source = "./modules/route_53"

  route53_zone_config = local.route_53_config
}
