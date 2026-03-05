module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "imagify-repo"
  # Add this line to allow overwriting tags
  repository_image_tag_mutability = "MUTABLE" 

  repository_read_write_access_arns = [aws_iam_role.ecs_execution_role.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 versioned images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }

    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
