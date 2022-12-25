# 보안 그륩
# 위치 : EC2 > 네트워크 및 보안 > 보안 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "saju-db-sg-${var.service_type}"
  description = "saju db security group production"
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
    Name = "saju-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# 서브넷 그룹 생성 (private subnet 2개)
# 위치 : RDS > 서브넷 그룹
resource "aws_db_subnet_group" "subnet-group" {
  name       = "saju-private-subnet-group-${var.service_type}"
  subnet_ids = [var.private_subnet1_id, var.private_subnet2_id]

  tags = {
    Name = "saju-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# RDS
# 위치 : RDS > 데이터베이스
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "rds" {
  identifier = "saju-db-${var.service_type}"                   //DB 인스턴스 식별자
  db_subnet_group_name = aws_db_subnet_group.subnet-group.id   //서브넷 그룹
  engine               = "mysql"                               //엔진 유형
  engine_version       = "8.0.28"                              //MySQL 버전
  instance_class       = var.instance_class                    //DB 인스턴스 클래스
  username             = var.username                          //마스터 사용자 이름
  password             = var.password                          //마스터 암호
  parameter_group_name = "default.mysql8.0"                    //DB 파라미터 그룹
  allocated_storage     = 20                                   //할당된 스토리지
  max_allocated_storage = 1000                                 //최대 스토리지 임계값
  publicly_accessible = var.publicly_accessible                //퍼블릭액세스 가능
  vpc_security_group_ids = [aws_security_group.sg.id]          //기본 VPC 보안 그룹  
  availability_zone = "ap-northeast-2a"                        //가용 영역
  port = 3306                                                  //데이터베이스 포트
  skip_final_snapshot  = true
  
  tags = {
    Name = "saju-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

