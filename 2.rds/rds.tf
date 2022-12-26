# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# 디폴트 VPC
# 위치 : VPC > Virtual Private Cloud > VPC
variable "vpc_id" {
    default = "vpc-57cfa73f"  
}

# 보안 그륩
# 위치 : EC2 > 네트워크 및 보안 > 보안 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "saju-db-sg-test"
  description = "saju db security group test"
  vpc_id      = var.vpc_id
  # 인바운드 규칙   
  ingress {
    description      = ""
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "saju-db-sg-test"
    Service = "saju-test"
  }
}


# RDS
# 위치 : RDS > 데이터베이스
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "rds" {
  identifier = "saju-db-test"               //DB 인스턴스 식별자
  engine               = "mysql"            //엔진 유형
  engine_version       = "8.0.28"           //MySQL 버전
  instance_class       = "db.t2.micro"      //DB 인스턴스 클래스
  username             = "admin"            //마스터 사용자 이름
  password             = "1234abcd"         //마스터 암호
  parameter_group_name = "default.mysql8.0" //DB 파라미터 그룹
   allocated_storage     = 20               //할당된 스토리지
  max_allocated_storage = 1000              //최대 스토리지 임계값
  publicly_accessible = true                //퍼블릭액세스 가능
  vpc_security_group_ids = [aws_security_group.sg.id] //기본 VPC 보안 그룹  
  availability_zone = "ap-northeast-2a"     //가용 영역
  port = 3306                               //데이터베이스 포트
  skip_final_snapshot  = true
  tags = {
    Name = "saju-db-test"
    Service = "saju-test"
  }
}

# RDS 엔드포인트
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}