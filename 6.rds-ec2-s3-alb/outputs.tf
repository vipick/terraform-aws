# EC2
# 탄력적 IP
output "eip_ip" {
  value = module.ec2.eip_ip
}


# RDS
# RDS 엔드포인트
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}


# S3 정적 웹 호스팅 엔드포인트
output "s3_endpoint" {
  value = module.s3.s3_endpoint
}


# 로드밸런서 주소
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
