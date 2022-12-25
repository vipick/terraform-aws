# 로드밸런서 주소
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
