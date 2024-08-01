locals {
  # sharing information
  vpc_id_ap   = var.security_group_config["ap-northeast-2"].vpc_id
  vpc_id_us   = var.security_group_config["us-west-2"].vpc_id
  vpc_cidr_ap = var.security_group_config["ap-northeast-2"].vpc_cidr
  vpc_cidr_us = var.security_group_config["us-west-2"].vpc_cidr

  # security group information
  security_group_setting = {
    common_egress_rule = ["all-all"]
    vpc_endpoint = {
      ap-northeast-2 = {
        name = "${var.convention}-sg-endpoint"
        ingress_rule = [
          {
            from_port   = "443"
            to_port     = "443"
            protocol    = "tcp"
            cidr_blocks = local.vpc_cidr_ap
          },
          {
            from_port   = "443"
            to_port     = "443"
            protocol    = "tcp"
            cidr_blocks = local.vpc_cidr_us
          },
          {
            from_port   = "53"
            to_port     = "53"
            protocol    = "udp"
            cidr_blocks = local.vpc_cidr_ap
          },
          {
            from_port   = "53"
            to_port     = "53"
            protocol    = "udp"
            cidr_blocks = local.vpc_cidr_us
          }
        ]
      }
      us-west-2 = {
        name = "${var.convention}-sg-endpoint"
        ingress_rule = [
          {
            from_port   = 0
            to_port     = 0
            protocol    = -1
            cidr_blocks = local.vpc_cidr_ap
          },
          {
            from_port   = 0
            to_port     = 0
            protocol    = -1
            cidr_blocks = local.vpc_cidr_us
          },
        ]
      }
    }
    
    
    ec2-instance = {
      eks_bastion = {
        name = "${var.convention}-sg-eks-bastion"
        ingress_rule = [
          {
            from_port   = "80"
            to_port     = "80"
            protocol    = "tcp"
            cidr_blocks = "0.0.0.0/0"
          }
        ]
      },
      app_server = {
        name = "${var.convention}-sg-app-server"
        ingress_rule = [
          {
            from_port   = "80"
            to_port     = "80"
            protocol    = "tcp"
            cidr_blocks = "10.0.0.0/16"
          }
        ]
      }
    }
    
    elb = {
      application = {
        name = "${var.convention}-sg-alb"
        ingress_rule = [
          {
            from_port   = 0
            to_port     = 0
            protocol    = -1
            cidr_blocks = local.vpc_cidr_ap
          }
        ]
      }
    }
    
    
    rds = {
      aurora_postgresql = {
        name = "${var.convention}-sg-rds-aurora-postgresql"
        ingress_rule = [
          {
            from_port   = 5432
            to_port     = 5432
            protocol    = -1
            cidr_blocks = local.vpc_cidr_ap
          }
        ]
      }
    }
  }
}
