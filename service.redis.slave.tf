resource "aws_ecs_service" "redis-slave" {
  name            = "service-redis-slave"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.redis-slave.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }

  network_configuration {
    security_groups = [aws_security_group.n8n_redis_sg.id]
    subnets         = concat(aws_subnet.public.*.id)
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  depends_on = [ # ⬅️ Adicionando dependência aqui
    aws_ecs_service.n8n_main,
    aws_ecs_service.worker,
    aws_ecs_service.redis-master
  ]

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "null_resource" "wait_for_services" {
  depends_on = [
    aws_ecs_service.n8n_main,
    aws_ecs_service.worker,
    aws_ecs_service.redis-master,
  ]

  provisioner "local-exec" {
    command = "sleep 120" # Aguarda 120 segundos antes de continuar
  }
}


