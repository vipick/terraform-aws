# 디폴트 VPC
variable "vpc_id" {
  type = string 
}

# 서비스 타입
variable "service_type" {
  type = string 
}

# DB 인스턴스 클래스
variable "instance_class" {
  type = string 
}


variable "username" {
  type = string 
}

variable "password" {
  type = string 
}

//퍼블릭액세스 가능
variable "publicly_accessible" {
  type = bool 
}


