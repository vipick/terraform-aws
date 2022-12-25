# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# 디폴트 VPC
# 위치 : VPC > Virtual Private Cloud > VPC
variable "vpc_id" {
    default = "vpc-57cfa73f"
}


# 보안 그룹
# 위치 : EC2 > 네트워크 및 보안 > 보안 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "saju-api-sg-test"
  description = "saju api security group test"
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
    Name = "saju-test"
  }
}

# EC2
# 위치 : EC2 > 인스턴스 > 인스턴스
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ec2" {
  ami           = "ami-0263588f2531a56bd"   //AMI 선택
  instance_type = "t2.micro"                //인스턴스 유형
  key_name = "saju-key-test"                //기존 키 페어 선택
  vpc_security_group_ids = [aws_security_group.sg.id]  //기존 보안 그룹 선택
  availability_zone = "ap-northeast-2a"     //가용 영역
  user_data = file("./userdata.sh")
  //스토리지 추가
  root_block_device  {
      volume_size = 30     //크기(GiB)
      volume_type = "gp2"  //볼륨 유형
  }

  tags = {
    Name = "saju-api-test"
  }
}

# 탄력적 IP 주소 할당
# 위치 : EC2 > 네트워크 및 보안 > 탄력적 IP
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "eip" {
  instance = aws_instance.ec2.id
  vpc      = true

  tags = {
    Name = "saju-ec2-eip-test"
  }
}

# 탄력적 IP
output "eip_ip" {
  value = aws_eip.eip.public_ip
}