# viraibles setting 
locals {
  convention = "aj-genai"
  account_id = data.aws_caller_identity.aws_account_info.account_id
  # account_user_arn = data.aws_caller_identity.aws_account_info.arn
  # account_user_id  = data.aws_caller_identity.aws_account_info.user_id

  vpc = {
    ap-northeast-2 = {
      region                = "ap-northeast-2"
      vpc_cidr              = "10.0.0.0/16"
      vpc_name              = "${local.convention}-vpc-ap"
      azs                   = ["ap-northeast-2a", "ap-northeast-2c"]
      public_subnets        = ["10.0.1.0/24", "10.0.2.0/24"]
      private_subnets       = ["10.0.41.0/24", "10.0.42.0/24"]
      database_subnets      = ["10.0.81.0/24", "10.0.82.0/24"]
      public_subnet_names   = ["${local.convention}-subnet-public-01", "${local.convention}-subnet-public-02"]
      private_subnet_names  = ["${local.convention}-subnet-private-01", "${local.convention}-subnet-private-02"]
      database_subnet_names = ["${local.convention}-subnet-database-01", "${local.convention}-subnet-database-02"]
    }
    us-west-2 = {
      region                = "us-west-2"
      vpc_cidr              = "10.1.0.0/16"
      vpc_name              = "${local.convention}-vpc-us"
      azs                   = ["us-west-2a", "us-west-2c"]
      public_subnets        = ["10.1.1.0/24", "10.1.2.0/24"]
      private_subnets       = ["10.1.41.0/24", "10.1.42.0/24"]
      database_subnets      = ["10.1.81.0/24", "10.1.82.0/24"]
      public_subnet_names   = ["${local.convention}-subnet-public-01", "${local.convention}-subnet-public-02"]
      private_subnet_names  = ["${local.convention}-subnet-private-01", "${local.convention}-subnet-private-02"]
      database_subnet_names = ["${local.convention}-subnet-database-01", "${local.convention}-subnet-database-02"]
    }
  }

  vpc_peering_name = "${local.convention}-peering-ap-us"

  enpoints = {
    convention = local.convention
    ap-northeast-2 = {
      region = "ap-northeast-2"
      vpc_id = module.vpc_ap_northeast_2.vpc_id

      endpoint = {
        s3 = {
          service             = "s3"
          subnet_ids          = null
          security_group_ids  = null
          private_dns_enabled = null
          tags = {
            Name  = "${local.convention}-vpc-endpoint-s3"
            Owner = "sh1517.you"
          }
        },
        sts = {
          service             = "sts"
          subnet_ids          = module.vpc_ap_northeast_2.private_subnets
          security_group_ids  = [module.security_groups.ap_northeast_2_vpc_endpoint_security_group_id]
          private_dns_enabled = true
          tags                = { Name = "${local.convention}-vpc-endpoint-sts" }
        }
      }
    }
    us-west-2 = {
      region = "us-west-2"
      vpc_id = module.vpc_us_west_2.vpc_id

      endpoint = {
        s3 = {
          service             = "s3"
          subnet_ids          = null
          security_group_ids  = null
          private_dns_enabled = null
          tags                = { Name = "${local.convention}-vpc-endpoint-s3" }
        },
        sts = {
          service             = "sts"
          subnet_ids          = module.vpc_us_west_2.private_subnets
          security_group_ids  = [module.security_groups.us_west_2_vpc_endpoint_security_group_id]
          private_dns_enabled = true
          tags                = { Name = "${local.convention}-vpc-endpoint-sqs" }
        },
        bedrock = {
          service             = "bedrock"
          subnet_ids          = module.vpc_us_west_2.private_subnets
          security_group_ids  = [module.security_groups.us_west_2_vpc_endpoint_security_group_id]
          private_dns_enabled = false
          tags                = { Name = "${local.convention}-vpc-endpoint-bedrock" }
        },
        bedrock-runtime = {
          service             = "bedrock-runtime"
          subnet_ids          = module.vpc_us_west_2.private_subnets
          security_group_ids  = [module.security_groups.us_west_2_vpc_endpoint_security_group_id]
          private_dns_enabled = false
          tags                = { Name = "${local.convention}-vpc-endpoint-bedrock-runtime" }
        }
      }
    }
  }

  key_pair_config = {
    ap-northeast-2 = {
      ec2 = {
        key_name           = "${local.convention}-pem-ec2-ap"
        create_private_key = "true"
        save_path_pem      = "${local.convention}-pem-ec2-ap.pem"
        pem_key_permission = "0600"
      }
    },
    us-east-2 = {
    }
  }

  ec2_instace_config = {
    ap-northeast-2 = {
      ec2-app-server = {
        ami                    = data.aws_ami.amazon_linux_2023.id
        key_name               = local.key_pair_config.ap-northeast-2.ec2.key_name
        instance_type          = "c7i.2xlarge"
        subnet_id              = module.vpc_ap_northeast_2.private_subnets[1]
        vpc_security_group_ids = [module.security_groups.ap_northeast_2_ec2_app_server_security_group_id]

        volume_size = 100
        tag_name    = "${local.convention}-ec2-llm-app"

        user_data = <<-EOF
            #!/bin/bash
            # Python 3.11 설치 스크립트
            echo "#####################"
            echo "Python 3.11 설치 시작"
            echo "npde.js 10.5 설치 시작"
            echo "nginx 설치 시작"
            echo "#####################"
            sudo dnf install python3.11 -y
            sudo dnf install npm -y
            sudo dnf install nginx -y

            echo "##############################"
            echo "Python Default Version Setting"
            echo "update-alternatives 명령 실행."
            echo "##############################"
            sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
            sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
            echo 2 | sudo update-alternatives --config python3
            
            echo "################################"
            echo "Python 3.11 PIP Module 설치 시작"
            echo "################################"
            python3 -m ensurepip --default-pip

            echo "##############################"
            echo "Python3 → Python Symbolic link"
            echo "##############################"
            echo "sudo ln -fs /usr/bin/python3.11 /usr/bin/python"
            sudo ln -fs /usr/bin/python3.11 /usr/bin/python

            echo "#####################################"
            echo "dnf/yum에서 사용하는 Python 버전 지정"
            echo "#####################################"
            head -1 /usr/bin/dnf
            sudo sed -i 's|#!/usr/bin/python3|#!/usr/bin/python3.9|g' /usr/bin/dnf
            sudo sed -i 's|#!/usr/bin/python3|#!/usr/bin/python3.9|g' /usr/bin/yum
            head -1 /usr/bin/dnf
            sudo dnf --version

            echo "################"
            echo "PIP Upgrade 설치"
            echo "################"
            python3 -m pip install --upgrade pip

            echo "##################"
            echo "Git & Code Install"
            echo "##################"
            yum install git -y
          EOF

        iam_instance_profile = module.iam_role.iam_instance_profile_name_ec2
      }
    }
    us-west-2 = {
    }
  }

  iam_role_config = {
    ec2 = {
      role_name         = "${local.convention}-role-ec2-core"
      role_requires_mfa = false

      create_role             = true
      create_instance_profile = true
      attach_poweruser_policy = false
      attach_admin_policy     = false

      trusted_role_actions    = ["sts:AssumeRole", "sts:TagSession"]
      trusted_role_services   = ["ec2.amazonaws.com"]
      custom_role_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    },
  }

  rds_aurora_config = {
    ap-northeast-2 = {
      name = "${local.convention}-rds-aurora-postgresql"

      username       = "postgres"
      password       = "qwer1234"
      database_name  = "ai"
      engine         = "aurora-postgresql"
      engine_version = "13.12"
      instance_type  = "db.t3.medium"

      vpc_id                 = module.vpc_ap_northeast_2.vpc_id
      db_subnet_group_name   = module.vpc_ap_northeast_2.database_subnet_group_name
      vpc_security_group_ids = [module.security_groups.ap_northeast_2_rds_aurora_postgresql_security_group_id]

      tag_name = "${local.convention}-rds-aurora-postgresql"
    }
    us-west-2 = {

    }
  }

  s3_bucket_config = {
    ap-northeast-2 = {
      name = "${local.convention}-bucket-preprocessing"
    }
  }

  application_lb_config = {
    ap-northeast-2 = {
      name    = "${local.convention}-alb-llm-app"
      vpc_id  = module.vpc_ap_northeast_2.vpc_id
      subnets = module.vpc_ap_northeast_2.public_subnets

      create_security_group      = false
      enable_deletion_protection = false

      security_groups = [module.security_groups.ap_northeast_2_alb_security_group_id]
      listeners = {
        ex-http = {
          port     = 80
          protocol = "HTTP"

          forward = {
            target_group_key = "${local.convention}-tg-llm-app"
          }

          rules = {
            default = {
              priority = 9999
              actions = {
                type               = "forward"
                target_group_key   = "${local.convention}-tg-llm-frontend"
              }
            }
            backend = {
              priority = 2
              actions = {
                type               = "forward"
                target_group_key   = "${local.convention}-tg-llm-backend"
              }
              conditions = {
                path_patterns = ["/bedrock/*", /maintenances*, /auth*]
              }
            }
          }
        }
      }
      
      target_groups = {
        "${local.convention}-tg-llm-frontend" = {
          protocol    = "HTTP"
          port        = 3000
          target_type = "instance"
          target_id   = module.ec2_ap_northeast_2.ec2_instance_id["ec2-app-server"].instance_id
        },
        "${local.convention}-tg-llm-backend" = {
          protocol    = "HTTP"
          port        = 8001
          target_type = "instance"
          target_id   = module.ec2_ap_northeast_2.ec2_instance_id["ec2-app-server"].instance_id
        }}

      health_check = {
        target              = "HTTP:3000/"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        matcher             = "302"
      }
    }
  }

  route_53_config = {
    "bedrock-runtime" = {
      name   = "bedrock-runtime"
      region = "us-west-2"
      vpc_id = module.vpc_ap_northeast_2.vpc_id
      name_zone = {
        name    = module.vpc_endpoints_us_west_2.vpc_endpoints_information["bedrock-runtime"].dns_name
        zone_id = module.vpc_endpoints_us_west_2.vpc_endpoints_information["bedrock-runtime"].hosted_zone_id
      }
    }
    "bedrock" = {
      name   = "bedrock"
      region = "us-west-2"
      vpc_id = module.vpc_ap_northeast_2.vpc_id
      name_zone = {
        name    = module.vpc_endpoints_us_west_2.vpc_endpoints_information["bedrock"].dns_name
        zone_id = module.vpc_endpoints_us_west_2.vpc_endpoints_information["bedrock"].hosted_zone_id
      }
    }
  }

}
