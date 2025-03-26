resource "aws_ecs_task_definition" "redis-master" {
  family                   = "redis-master-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name" : "redis-master",
      "image" : "redis:6-alpine",
      "command" : ["redis-server"],
      "cpu" : 256,
      "memoryReservation" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "name" : "porta_6379",
          "containerPort" : 6379,
          "hostPort" : 6379,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/redis-task",
          "mode" : "non-blocking",
          "awslogs-create-group" : "true",
          "max-buffer-size" : "25m",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "mountPoints" : [
        {
          "sourceVolume" : "redis-data",
          "containerPath" : "/data",
          "readOnly" : false
        }
      ]
    }
  ])

  volume {
    name = "redis-data"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.redis.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 0
      authorization_config {
        access_point_id = null
        iam             = "ENABLED"
      }
    }
  }

  tags = {
    Environment = "production"
    Name        = "redis-master"
  }
}

