output "aws_ecs_cluster" {
  value = aws_ecs_cluster.imagify.name
}

output "aws_ecs_service" {
  value = aws_ecs_service.imagify.name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}