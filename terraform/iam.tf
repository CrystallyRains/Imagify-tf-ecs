resource "aws_iam_role" "ecs_execution_role" {
  name = "imagify-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -------------------------------------------------------
# Allows ECS to read SSM SecureString secrets at task startup
# (needed so container env vars can reference SSM params)
# -------------------------------------------------------
resource "aws_iam_policy" "ecs_ssm_policy" {
  name = "imagify-ecs-ssm-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"

        # Scoped to only imagify params — don't give access to everything
        Resource = "arn:aws:ssm:us-east-1:*:parameter/imagify/*"
      },
      {
        # SecureStrings are encrypted with KMS — execution role needs decrypt permission
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*" # Scope to your KMS key ARN if you have a custom one
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_ssm_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_ssm_policy.arn
}


resource "aws_iam_policy" "imagify_s3_policy" {
  name = "imagify-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject"
      ]
      Resource = "arn:aws:s3:::imagify-uploads/*"
    }]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "imagify-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project     = "imagify"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.imagify_s3_policy.arn
}
