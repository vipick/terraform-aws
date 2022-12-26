# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# VPC
# 위치 : VPC > Virtual Private Cloud > VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16" //IPv4 CIDR 수동 입력
  instance_tenancy     = "default"     //테넌시 - 기본값
  enable_dns_hostnames = true

  tags = {
    Name = "saju-vpc-test"  //이름 태그
    Service = "saju-test"
  }
}

# 퍼블릭 서브넷1
# 위치 : VPC > Virtual Private Cloud > 서브넷
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id    //VPC ID
  cidr_block              = "10.0.0.0/24"     //IPv4 CIDR 블록  
  availability_zone       = "ap-northeast-2a" //가용 영역
  map_public_ip_on_launch = true
  tags = {
    Name = "saju-public-subnet1-test" //서브넷 이름
    Service = "saju-test"
  }
}

# 퍼블릭 서브넷2
# 위치 : VPC > Virtual Private Cloud > 서브넷
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "saju-public-subnet2-test"
    Service = "saju-test"
  }
}

# 프라이빗 서브넷1
# 위치 : VPC > Virtual Private Cloud > 서브넷
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "saju-private-subnet1-test"
    Service = "saju-test"
  }
}

# 프라이빗 서브넷2
# 위치 : VPC > Virtual Private Cloud > 서브넷
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "saju-private-subnet2-test"
    Service = "saju-test"
  }
}

# 인터넷 게이트웨이
# 위치 : VPC > Virtual Private Cloud > 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id //사용 가능한 VPC

  tags = {
    Name = "saju-igw-test"
    Service = "saju-test"
  }
}

# 탄력적 IP 할당
# 위치 : VPC > Virtual Private Cloud > 탄력적 IP
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "saju-natgw-eip-test"
    Service = "saju-test"
  }
}

# NAT 게이트웨이
# 위치 : VPC > Virtual Private Cloud > NAT 게이트웨이
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id                //탄력적 IP 할당 ID
  subnet_id     = aws_subnet.public-subnet-1.id //퍼블릭 서브넷 1

  tags = {
    Name = "saju-natgw-test"
    Service = "saju-test"
  }
}

# 퍼블릭 라우팅 테이블
# 위치 : VPC > Virtual Private Cloud > 라우팅 테이블
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"                 //Destination (대상)
    gateway_id = aws_internet_gateway.igw.id //Target (대상)
  }

  tags = {
    Name = "saju-public-rt-test"    //라우팅 테이블 이름
    Service = "saju-test"
  }
}

# 프라이빗 라우팅 테이블
# 위치 : VPC > Virtual Private Cloud > 라우팅 테이블
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"              //Destination (대상)
    gateway_id = aws_nat_gateway.natgw.id //Target (대상)
  }

  tags = {
    Name = "saju-private-rt-test"
    Service = "saju-test"
  }
}

# 퍼블릭 라우팅 테이블에 퍼블릭 서브넷1 연결
resource "aws_route_table_association" "public-rt-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

# 퍼블릭 라우팅 테이블에 퍼블릭 서브넷2 연결
resource "aws_route_table_association" "public-rt-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

# 프라이빗 라우팅 테이블에 프라이빗 서브넷1 연결
resource "aws_route_table_association" "private-rt-association-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

# 프라이빗 라우팅 테이블에 프라이빗 서브넷2 연결
resource "aws_route_table_association" "private-rt-association-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}