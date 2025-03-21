# Cria o grupo de subnets privadas para o RDS
resource "aws_db_subnet_group" "aurora_subnet" {
  name = "rds-subnet-group-n8n-qm-tf"
  subnet_ids = [aws_subnet.private.0.id,
    aws_subnet.private.1.id
  ]
  description = "Subnet group do Aurora"

}