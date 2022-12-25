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
# default vpc : vpc-57cfa73f  
# 사용자 마다 디폴트 VPC는 다릅니다. AWS에서 확인이 필요

# EC2
module "ec2" {
  source         = "./ec2"
  service_type   = var.service_type
  vpc_id         = var.vpc_id
  instance_type  = "t2.micro"
  user_data_path = "./ec2/userdata.sh" 
}

# RDS
module "rds" {
  source              = "./rds"
  service_type        = var.service_type
  vpc_id              = var.vpc_id
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "1234abcd"
  publicly_accessible = true
}

# S3
module "s3" {
  source       = "./s3"
  service_type = var.service_type
  vpc_id       = var.vpc_id
  bucket       = "saju-front-${var.service_type}"
}

# ALB
# default vpc 서브넷 : ["subnet-3ae29a52", "subnet-a29b35ee"] 
# 사용자 마다 디폴트 서브넷은 다릅니다. AWS에서 확인이 필요
module "alb" {
  source       = "./alb"
  service_type = var.service_type
  vpc_id       = var.vpc_id
  subnet_ids   = ["subnet-3ae29a52", "subnet-a29b35ee"] 

  depends_on = [module.ec2] 
}

