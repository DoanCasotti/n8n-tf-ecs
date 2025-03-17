resource "aws_ecs_task_definition" "n8n_worker" {
  family                   = "n8n-worker"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn


  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name" : "n8n-worker",
      "image" : "n8nio/n8n:1.82.0",
      "cpu" : 1024,
      "memoryReservation" : 819,
      "essential" : true,
      "command" : ["worker"],
      "environment" : [
        { "name" : "QUEUE_BULL_REDIS_DB", "value" : "0" },
        { "name" : "DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED", "value" : "false" },
        { "name" : "DB_POSTGRESDB_DATABASE", "value" : "${var.rds_db_name}" },
        { "name" : "N8N_LOG_LEVEL", "value" : "debug" },
        { "name" : "EXECUTIONS_MODE", "value" : "queue" },
        { "name" : "QUEUE_BULL_REDIS_HOST", "value" : "service.redis" },
        { "name" : "DB_POSTGRESDB_PASSWORD", "value" : "${var.rds_password}" },
        { "name" : "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS", "value" : "true" },
        { "name" : "N8N_PORT", "value" : "5678" },
        { "name" : "DB_POSTGRESDB_HOST", "value" : "${aws_db_instance.this.address}" },
        { "name" : "DB_TYPE", "value" : "postgresdb" },
        { "name" : "QUEUE_BULL_REDIS_PORT", "value" : "6379" },
        { "name" : "DB_POSTGRESDB_USER", "value" : "${var.rds_username}" },
        { "name" : "N8N_ENCRYPTION_KEY", "value" : "${var.N8N_ENCRYPTION_KEY}" },
        { "name" : "N8N_RELEASE_DATE", "value" : "2024-06-12T12:34:56Z" },
        { "name" : "GENERIC_TIMEZONE", "value" : "America/Sao_Paulo" },
        { "name" : "QUEUE_BULL_PREFIX", "value" : "bull:jobs" }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/n8n-worker",
          "mode" : "non-blocking",
          "awslogs-create-group" : "true",
          "max-buffer-size" : "25m",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  tags = {
    Environment = "production"
    Name        = "n8n-worker"
  }
}
