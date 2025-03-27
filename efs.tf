# EFS File System
resource "aws_efs_file_system" "redis" {
  creation_token = "redis-efs"

  # Configurações para tornar o EFS regional
  availability_zone_name = null

  # Performance configuration
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  encrypted        = true

  # Lifecycle management policies
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  # Optional: if you want to archive
  lifecycle_policy {
    transition_to_archive = "AFTER_90_DAYS"
  }


  tags = {
    Name        = "redis-efs"
    Environment = "production"
    Scope       = "Regional"
    ManagedBy   = "Terraform"
  }
}

resource "aws_efs_backup_policy" "redis_backup_policy" {
  file_system_id = aws_efs_file_system.redis.id

  backup_policy {
    status = "ENABLED"
  }
}

# EFS Mount Targets for both subnets
resource "aws_efs_mount_target" "redis_mount_a" {
  file_system_id  = aws_efs_file_system.redis.id
  subnet_id       = aws_subnet.public[0].id
  security_groups = [aws_security_group.redis_efs.id]
}

resource "aws_efs_mount_target" "redis_mount_b" {
  file_system_id  = aws_efs_file_system.redis.id
  subnet_id       = aws_subnet.public[1].id
  security_groups = [aws_security_group.redis_efs.id]
}