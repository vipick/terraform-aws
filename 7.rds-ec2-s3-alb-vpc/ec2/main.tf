# 보안 그룹
# 위치 : EC2 > 네트워크 및 보안 > 보안 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "saju-api-sg-${var.service_type}"
  description = "saju api security group production"
  vpc_id      = var.vpc_id

  # 인바운드 규칙   
  ingress {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = ""
    from_port        = 3000
    to_port          = 3000
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
    Name = "saju-api-sg-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# EC2
# 위치 : EC2 > 인스턴스 > 인스턴스
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ec2" {
  ami           = "ami-0263588f2531a56bd"              //AMI 선택
  instance_type = var.instance_type                    //인스턴스 유형
  key_name = "saju-key-${var.service_type}"            //기존 키 페어 선택
  subnet_id = var.private_subnet1_id                   //서브넷
  vpc_security_group_ids = [aws_security_group.sg.id]  //기존 보안 그룹 선택
  availability_zone = "ap-northeast-2a"                //가용 영역
  user_data = file(var.user_data_path)
  //스토리지 추가
  root_block_device  {
      volume_size = 30     //크기(GiB)
      volume_type = "gp2"  //볼륨 유형
  }

  tags = {
    Name = "saju-api-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

