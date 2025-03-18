resource "aws_ecs_task_definition" "n8n" {
  family                   = "task-n8n"
  network_mode            = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "717"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::148761658767:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::148761658767:role/role-ecs-task-definition-efs"

  container_definitions = jsonencode([
    {
      name  = "n8n"
      image = "n8nio/n8n:1.82.0"
      cpu   = 717
      memoryReservation = 512
      essential = true
      portMappings = [
        {
          name          = "porta_n8n"
          containerPort = 5678
          hostPort      = 0
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        { name = "QUEUE_BULL_REDIS_DB", value = "0" },
        { name = "N8N_API_TRUST_PROXY", value = "true" },
        { name = "WEBHOOK_URL", value = "https://n8n10.alisriosti.com.br" },
        { name = "DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED", value = "false" },
        { name = "DB_POSTGRESDB_DATABASE", value = "n8n" },
        { name = "N8N_LOG_LEVEL", value = "debug" },
        { name = "EXECUTIONS_MODE", value = "queue" },
        { name = "QUEUE_BULL_REDIS_HOST", value = "service.redis" },
        { name = "DB_POSTGRESDB_PASSWORD", value = "${var.rds_password}"},
        { name = "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS", value = "true" },
        { name = "N8N_HOST", value = "n8n10.alisriosti.com.br" },
        { name = "N8N_PROTOCOL", value = "https" },
        { name = "DB_POSTGRESDB_HOST", value = "${aws_db_instance.this.address}"},
        { name = "DB_TYPE", value = "postgresdb" },
        { name = "QUEUE_BULL_REDIS_PORT", value = "6379" },
        { name = "DB_POSTGRESDB_USER", value = "${var.rds_username}"},
        { name = "N8N_ENCRYPTION_KEY", value = "${var.N8N_ENCRYPTION_KEY}"},
        { name = "GENERIC_TIMEZONE", value = "America/Sao_Paulo" },
        { name = "QUEUE_BULL_PREFIX", value = "bull:jobs" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/n8n-task"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "n8n"
        }
      }
    }
  ])

  tags = {
    Environment = "production"
    Service     = "service-n8n-marcio"
    Namespace   = "n8nmarcio"
  }
}