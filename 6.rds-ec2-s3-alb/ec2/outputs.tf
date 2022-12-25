# 탄력적 IP
output "eip_ip" {
  value = aws_eip.eip.public_ip
}

