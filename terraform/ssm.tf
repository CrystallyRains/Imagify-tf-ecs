resource "aws_ssm_parameter" "mongodb_url" {
  name  = "/imagify/dev/mongodb_url"
  type  = "SecureString"
  value = var.mongodb_url
}

resource "aws_ssm_parameter" "clerk_publishable_key" {
  name  = "/imagify/dev/clerk_publishable_key"
  type  = "SecureString"
  value = var.clerk_publishable_key
}

resource "aws_ssm_parameter" "clerk_secret_key" {
  name  = "/imagify/dev/clerk_secret_key"
  type  = "SecureString"
  value = var.clerk_secret_key
}

resource "aws_ssm_parameter" "cloudinary_api_key" {
  name  = "/imagify/dev/cloudinary_api_key"
  type  = "SecureString"
  value = var.cloudinary_api_key
}

resource "aws_ssm_parameter" "cloudinary_api_secret" {
  name  = "/imagify/dev/cloudinary_api_secret"
  type  = "SecureString"
  value = var.cloudinary_api_secret
}

resource "aws_ssm_parameter" "stripe_secret_key" {
  name  = "/imagify/dev/stripe_secret_key"
  type  = "SecureString"
  value = var.stripe_secret_key
}

resource "aws_ssm_parameter" "stripe_publishable_key" {
  name  = "/imagify/dev/stripe_publishable_key"
  type  = "SecureString"
  value = var.stripe_publishable_key
}

# -------------------------------------------------------
# Infra output params — written by infra.yml after apply
# Placeholders here so Terraform owns/tracks them.
# The actual values get overwritten by the workflow using --overwrite.
# -------------------------------------------------------

resource "aws_ssm_parameter" "ecr_repository_url" {
  name  = "/imagify/dev/ecr_repository_url"
  type  = "String"
  value = module.ecr.repository_url # known after apply — Terraform writes the real value
}

resource "aws_ssm_parameter" "ecs_cluster" {
  name  = "/imagify/dev/ecs_cluster"
  type  = "String"
  value = aws_ecs_cluster.imagify.name
}

resource "aws_ssm_parameter" "ecs_service" {
  name  = "/imagify/dev/ecs_service"
  type  = "String"
  value = aws_ecs_service.imagify.name
}
