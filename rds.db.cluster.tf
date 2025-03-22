resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.aurora_cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = "16"
  database_name           = var.aurora_db_name
  master_username         = var.aurora_username
  master_password         = var.aurora_password
  backup_retention_period = 1
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  storage_encrypted       = true
  deletion_protection     = false
  apply_immediately       = true
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "aurora_writer" {
  identifier          = "${var.aurora_cluster_identifier}-writer"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.t4g.medium"
  engine              = "aurora-postgresql"
  publicly_accessible = false
}

resource "aws_rds_cluster_instance" "aurora_reader" {
  identifier          = "${var.aurora_cluster_identifier}-reader"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.t4g.medium"
  engine              = "aurora-postgresql"
  publicly_accessible = false
}

