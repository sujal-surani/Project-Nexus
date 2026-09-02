data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_alb" "nexus_alb" {
  name = "nexus-api-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.nexus_sg.id ]
  subnets = data.aws_subnets.default.ids
}

resource "aws_alb_target_group" "nexus_tg" {
  name = "nexus-api-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_alb_target_group_attachment" "nexus_attach" {
  target_group_arn = aws_alb_target_group.nexus_tg.arn
  target_id = aws_instance.nexus_host.id
  port = 80
}

resource "aws_lb_listener" "nexus_listener" {
  load_balancer_arn = aws_alb.nexus_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nexus_tg.arn
  }
}
