# aws s3 rm s3://saju-front-prod --recursive
# terraform destroy 를 하기전에 S3 버킷 내용이 삭제되어야 한다.
# s3 버킷 생성시 AWS를 이용하는 모든 사용자들의 s3 버킷 이름과 중복해서 사용할 수 없습니다.

# AWS 리전
provider "aws" {
  region = "ap-northeast-2"
}

# S3 버킷
# 위치 : s3 > 버킷
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "s3" {
  bucket = "saju-front-test"   //버킷 이름
  acl    = "public-read"        //ACL 비활성화됨(권장)
  # 버킷 정책
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Policy1546621853468",
  "Statement": [
    {
      "Sid": "Stmt1546621828605",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::saju-front-test/*"
    }
  ]
}
POLICY

  //정적 웹 호스팅
  website {
    index_document = "index.html"  //인덱스 문서
    error_document = "index.html"  //오류 문서
  }

  tags = {
    Name = "saju-front-test"
    Service = "saju-test"
  }
}

# S3 정적 웹 호스팅 엔드포인트
output "s3_endpoint" {
  value = aws_s3_bucket.s3.website_endpoint
}
