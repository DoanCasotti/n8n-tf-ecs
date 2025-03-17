resource "aws_ecs_task_definition" "redis" {
  family                   = "redis-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["EC2"]
  task_role_arn           = "arn:aws:iam::148761658767:role/role-ecs-task-definition-efs"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  cpu    = 256
  memory = 512

  runtime_platform {
    cpu_architecture       = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name": "redis",
      "image": "redis:6-alpine",
      "cpu": 256,
      "memoryReservation": 512,
      "essential": true,
      "portMappings": [
        {
          "name": "porta_6379",
          "containerPort": 6379,
          "hostPort": 6379,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/redis-task",
          "mode": "non-blocking",
          "awslogs-create-group": "true",
          "max-buffer-size": "25m",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  tags = {
    "Environment" = "production"
    "Service"     = "service-redis"
    "Namespace"   = "redis"
  }
}
