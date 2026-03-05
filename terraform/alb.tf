#ALB
resource "aws_lb" "imagify_alb" {
  name               = "imagify-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}

# Target Group
resource "aws_lb_target_group" "imagify_tg" {
  name        = "imagify-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}

# Listener
resource "aws_lb_listener" "imagify_listener" {
  load_balancer_arn = aws_lb.imagify_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.imagify_tg.arn
  }
}