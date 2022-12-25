# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# 키 페어
# 위치 : EC2 > 네트워크 및 보안 > 키 페어
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# public_key 에는 id_rsa.pub 를 복사 붙여넣기 합니다. 
# 위치 : 섹션1 테라폼 개발 환경 구성 -> 소스코드 다운 및 실행 -> 2. 로컬 Powershell에서 key pair 생성 
resource "aws_key_pair" "key" {
  key_name   = "saju-key-test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCZx7JTLWM*********" //변경 필요

  tags = {
    Name = "saju-test"
  }
}

resource "aws_key_pair" "key2" {
  key_name   = "saju-key-prod"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCZx7JTLWM*********" //변경 필요

  tags = {
    Name = "saju-prod"
  }
}


