# ECS Cluster
resource "aws_ecs_cluster" "imagify" {
  name = "imagify-cluster"

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}

#ECS Task Definition
resource "aws_cloudwatch_log_group" "imagify_logs" {
  name              = "/ecs/imagify"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "imagify" {
  family                   = "imagify"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "imagify"
      image     = "${module.ecr.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      secrets = [
        { name = "MONGODB_URL", valueFrom = aws_ssm_parameter.mongodb_url.arn },
        { name = "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY", valueFrom = aws_ssm_parameter.clerk_publishable_key.arn },
        { name = "CLERK_SECRET_KEY", valueFrom = aws_ssm_parameter.clerk_secret_key.arn },
        { name = "CLOUDINARY_API_KEY", valueFrom = aws_ssm_parameter.cloudinary_api_key.arn },
        { name = "CLOUDINARY_API_SECRET", valueFrom = aws_ssm_parameter.cloudinary_api_secret.arn },
        { name = "NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME", valueFrom = aws_ssm_parameter.next_public_cloudinary_cloud_name.arn },
        { name = "STRIPE_SECRET_KEY", valueFrom = aws_ssm_parameter.stripe_secret_key.arn },
        { name = "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY", valueFrom = aws_ssm_parameter.stripe_publishable_key.arn }
      ]

      environment = [
        { name = "NEXT_PUBLIC_SERVER_URL", value = aws_lb.imagify_alb.dns_name },
        { name = "NEXT_PUBLIC_CLERK_SIGN_IN_URL", value = "/sign-in" },
        { name = "NEXT_PUBLIC_CLERK_SIGN_UP_URL", value = "/sign-up" },
        { name = "NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL", value = "/" },
        { name = "NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL", value = "/" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.imagify_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "imagify" {
  name            = "imagify-service"
  cluster         = aws_ecs_cluster.imagify.id
  task_definition = aws_ecs_task_definition.imagify.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.imagify_tg.arn
    container_name   = "imagify"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.imagify_listener
  ]

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}
