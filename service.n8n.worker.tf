resource "aws_ecs_service" "worker" {
  name            = "service-n8n-worker"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.n8n_worker.arn
  desired_count   = 2

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  depends_on = [aws_ecs_service.redis-master]

  lifecycle {
    ignore_changes = [desired_count]
  }
}
