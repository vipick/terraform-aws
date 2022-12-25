# 프라이빗 IP
output "private_ip" {
  value = aws_instance.ec2.private_ip
}

