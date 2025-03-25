# Security Group n8n-cluster-web-tf
resource "aws_security_group" "n8n_redis_sg" {
  name        = "n8n-redis-sg-tf"
  description = "Acesso ao n8n-redis-sg-tf"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "acesso do redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "n8n-redis-sg-tf"
  }

}

# Security Group n8n-cluster-ec2-tf
resource "aws_security_group" "n8n_cluster_ec2" {
  name        = "n8n-cluster-ec2-tf"
  description = "Acesso ao n8n-cluster-ec2-tf"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "acesso do n8n-cluster-alb-tf"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = []
    security_groups = [aws_security_group.n8n_cluster_alb_tf.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "n8n-cluster-ec2-tf"
  }

}

# Security Group n8n-cluster-alb-tf
resource "aws_security_group" "n8n_cluster_alb_tf" {
  name        = "n8n-cluster-alb-tf"
  description = "Acesso ao n8n-cluster-alb-tf"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "acesso para o mundo"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "acesso para o mundo"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "n8n-cluster-alb-tf"
  }

}

# Security Group for EFS
resource "aws_security_group" "redis_efs" {
  name        = "redis-efs-from-ec2-tf"
  description = "Security group para o Redis EFS"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks     = []
    security_groups = [aws_security_group.n8n_redis_sg.id]
    description     = "acesso do n8n-redis-sg-tf"
  }
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks     = []
    security_groups = [aws_security_group.n8n_cluster_ec2.id]
    description     = "acesso do n8n-cluster-ec2-tf"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-efs-from-ec2-tf"
  }
}