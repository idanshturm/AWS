terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
      random = {
        source  = "hashicorp/random"
        version = "~> 3.1"
    }
    
  }
}
provider "aws" {
  region = "us-east-1"
}

provider "random" {
  # don't need to specify the version here because it's done in required_providers.
}

module "asg" {
  source = "./ASG"
  asg_ami = module.ec2.AMI_id_output
  asg_ec2_sg = [module.firewall.security_group_APP_id]
  ec2_efs_dns_name = module.database.efs_dns_name
  ASG_Subnet_Group_IDS = flatten(module.network.Private_Subnets_APP_ids)
  ASG_Arn_ID = [module.loadbalancer.alb_target_group_arn]
}

module "dns" {
  source = "./DNS"
  alb_dns_name = module.loadbalancer.ALB_DNS_Name_output
  ALB_zone_id = module.loadbalancer.ALB_Zone_id_output
}


module "loadbalancer" {
  source = "./Load_Balancer"
  ALB_vpc_id = module.network.vpc_id
  ALB_ec2_az1_id = module.ec2.EC2_AZ1_id
  ALB_ec2_az2_id = module.ec2.EC2_AZ2_id
  ALB_Public_Subnets_ids = module.network.public_subnet_ids
  ALB_SG = [module.firewall.security_group_ALB_id]
}

module "ec2" {
  source = "./EC2"
  ec2_public_subnet_id_az1 = module.network.public_subnet_ids[0]
  ec2_bastion_host_SG = [module.firewall.security_group_bastion_host_id]
  ec2_efs_dns_name = module.database.efs_dns_name
  ec2_db_password =  module.database.db_master_password
  ec2_db_endpoint = module.database.db_endpoint
  ec2_private_subnet_APP_id_az1 = module.network.private_subnet_ids_az1[0]
  ec2_private_subnet_APP_SG_az1 = [module.firewall.security_group_APP_id]
  ec2_private_subnet_APP_id_az2 = module.network.private_subnet_ids_az2[0]
  ec2_private_subnet_APP_SG_az2 = [module.firewall.security_group_APP_id]
}

module "database" {
  source = "./Database"
  DB_Subnet_Group_IDS = module.network.db_subnet_group
  vpc_security_group_ids = [module.firewall.security_group_RDS]
  efs_subnet_id_az1 = module.network.db_subnet_group[0]
  efs_subnet_id_az2 = module.network.db_subnet_group[1]
  efs_SG = [module.firewall.security_group_EFS_id]
}

module "firewall" {
  source = "./Firewall"
  vpc_id  = module.network.vpc_id
}

module "network" {
  source = "./Network"
  
  subnet_data = {
    PublicSubnet_AZ1 = {
      cidr_block      = "172.16.0.80/28"
      availability_zone = "us-east-1a"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PublicSubnet-AZ1" }

    },
      PrivateSubnet1_APP_AZ1 = {
      cidr_block      = "172.16.0.96/28"
      availability_zone = "us-east-1a"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PrivateSubnet1-APP-AZ1" }
    },
      PrivateSubnet2_RDS_AZ1 = {
      cidr_block      = "172.16.0.112/28"
      availability_zone = "us-east-1a"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PrivateSubnet2-RDS-AZ1" }
    },
      PublicSubnet_AZ2 = {
      cidr_block      = "172.16.0.0/28"
      availability_zone = "us-east-1b"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PublicSubnet-AZ2" }
    },
      PrivateSubnet3_APP_AZ2 = {
      cidr_block      = "172.16.0.128/28"
      availability_zone = "us-east-1b"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PrivateSubnet3-APP-AZ2" }
    },
      PrivateSubnet4_RDS_AZ2 = {
      cidr_block      = "172.16.0.160/28"
      availability_zone = "us-east-1b"
      vpc_id  = module.network.vpc_id
      tags            = { Name = "PrivateSubnet4-RDS-AZ2" }
    }
}
}



