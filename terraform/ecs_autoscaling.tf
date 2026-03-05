# App Auto Scaling Target
resource "aws_appautoscaling_target" "imagify" {
  max_capacity       = 5 # maximum number of tasks
  min_capacity       = 2 # minimum number of tasks
  resource_id        = "service/${aws_ecs_cluster.imagify.name}/${aws_ecs_service.imagify.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU Utilization Scaling Policy
resource "aws_appautoscaling_policy" "cpu_scale_up" {
  name               = "imagify-cpu-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.imagify.resource_id
  scalable_dimension = aws_appautoscaling_target.imagify.scalable_dimension
  service_namespace  = aws_appautoscaling_target.imagify.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70 # desired CPU %
    scale_in_cooldown  = 120
    scale_out_cooldown = 120
  }
}

# Memory Utilization Scaling Policy (optional)
resource "aws_appautoscaling_policy" "memory_scale_up" {
  name               = "imagify-memory-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.imagify.resource_id
  scalable_dimension = aws_appautoscaling_target.imagify.scalable_dimension
  service_namespace  = aws_appautoscaling_target.imagify.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 75 # desired memory %
    scale_in_cooldown  = 120
    scale_out_cooldown = 120
  }
}