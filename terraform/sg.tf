resource "aws_security_group" "alb_sg" {
  name        = "imagify-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from internet"
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
    Project     = "imagify"
    Environment = "dev"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "imagify-ecs-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}