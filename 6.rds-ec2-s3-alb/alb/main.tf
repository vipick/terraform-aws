# 보안 그룹
# 위치 : EC2 > 네트워크 및 보안 > 보안 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "saju-alb-sg-${var.service_type}"
  description = "saju alb security group production"
  vpc_id      = var.vpc_id

  # 인바운드 규칙
  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "saju-alb-sg-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# 로드밸런서
# EC2 > 로드밸런싱 > 로드밸런서
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "alb" {
  name               = "saju-alb-${var.service_type}"   //로드밸런서 이름
  internal           = false                            //체계 : 인터넷 경계, IPv4
  load_balancer_type = "application"                    //로드밸런서 유형 : Application Load Balancer
  security_groups    = [aws_security_group.sg.id]       //보안 그룹
  subnets            = var.subnet_ids                   //네트워크 매핑

  enable_deletion_protection = false                    //삭제 방지 - 비활성화

  tags = {
    Name = "saju-alb-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# 리스너 및 라우팅
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "routing" {
  load_balancer_arn = aws_lb.alb.arn //로드밸런서
  port              = "80"           //포트
  protocol          = "HTTP"         //프로토콜


  default_action {
    type             = "forward"                  //다음으로 전달
    target_group_arn = aws_lb_target_group.tg.arn //대상 그룹
  }
}

# 대상 그룹
# EC2 > 로드밸런싱 > 대상 그룹
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "tg" {
  name        = "saju-tg-${var.service_type}" //대상 그룹 이름
  port        = 3000           //포트
  protocol    = "HTTP"         //프로토콜
  target_type = "instance"     //대상 유형 선택
  vpc_id      = var.vpc_id     //VPC
  health_check {               //상태 검사
    enabled  = true
    path     = "/"    //상태 검사 경로
    protocol = "HTTP" //상태 검사 프로토콜   

    # 고급 상태 검사 설정 
    port                = "traffic-port" //트래픽 포트
    healthy_threshold   = 3              //정상 임계값
    unhealthy_threshold = 2              //비정상 임계값
    timeout             = 5              //제한 시간
    interval            = 10             //간격
    matcher             = "200"          //성공 코드
  }
  
  tags = {
    Name = "saju-tg-${var.service_type}"
    Service = "saju-${var.service_type}"
  }
}

# 대상 등록
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attachment" {
  count = 1
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = element(data.aws_instances.tag.ids, count.index)
  port             = 3000 //선택한 인스턴스를 위한 포트
}

# 인스턴스 태그
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances
data "aws_instances" "tag" {
  instance_tags = {
    Name = "saju-api-${var.service_type}"
  }
}

