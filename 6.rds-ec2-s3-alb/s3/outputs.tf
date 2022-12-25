# S3 정적 웹 호스팅 엔드포인트
output "s3_endpoint" {
  value = aws_s3_bucket.s3.website_endpoint
}


