# RDS 엔드포인트
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}


