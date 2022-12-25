terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}

# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# [공통]
# service_type : prod | test
# VPC
module "vpc" {
  source       = "./vpc"
  service_type = var.service_type
}

# EC2
module "ec2" {
  source             = "./ec2"
  service_type       = var.service_type
  vpc_id             = module.vpc.vpc_id
  private_subnet1_id = module.vpc.private_subnet1_id
  instance_type      = "t2.micro"
  user_data_path     = "./ec2/userdata.sh"
}

# EC2 bastion
module "ec2-bastion" {
  source            = "./ec2-bastion"
  service_type      = var.service_type
  vpc_id            = module.vpc.vpc_id
  public_subnet1_id = module.vpc.public_subnet1_id
  instance_type     = "t2.micro"
}

# RDS
module "rds" {
  source              = "./rds"
  service_type        = var.service_type
  vpc_id              = module.vpc.vpc_id
  private_subnet1_id  = module.vpc.private_subnet1_id
  private_subnet2_id  = module.vpc.private_subnet2_id
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "1234abcd"
  publicly_accessible = false
}

# ALB
module "alb" {
  source       = "./alb"
  service_type = var.service_type
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = [module.vpc.public_subnet1_id, module.vpc.public_subnet2_id]

  depends_on = [module.ec2]
}

# S3
module "s3" {
  source       = "./s3"
  service_type = var.service_type
  vpc_id       = module.vpc.vpc_id
  bucket       = "saju-front-${var.service_type}"
}
