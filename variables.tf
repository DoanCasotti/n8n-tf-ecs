variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "Projeto-3-ECS"
  }
}

variable "aws_provider" {
  type = object({
    region = string,
    assume_role = object({
      role_arn = string
    })
  })

  default = {
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::975050217683:role/terraform-projeto3"
    }
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    })),
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })
  default = {
    cidr_block               = "172.36.0.0/16"
    name                     = "vpc-projeto3-ECS"
    internet_gateway_name    = "internet-gateway"
    public_route_table_name  = "public-route-table"
    private_route_table_name = "private-route-table"
    public_subnets = [{
      name                    = "public-subnet-us-east-1a"
      cidr_block              = "172.36.0.0/20"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "public-subnet-us-east-1b"
        cidr_block              = "172.36.16.0/20"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "private-subnet-us-east-1a"
      cidr_block              = "172.36.32.0/20"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "private-subnet-us-east-1b"
        cidr_block              = "172.36.48.0/20"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
    }]
  }
}

# Variáveis do RDS
variable "aurora_cluster_identifier" {
  description = "Identificador do cluster Aurora"
  type        = string
  default     = "aurora-n8n"
}

variable "aurora_db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "n8n"
}

variable "aurora_username" {
  description = "Usuário master do Aurora"
  type        = string
  default     = "postgres"
}

variable "aurora_password" {
  description = "Senha do usuário master"
  type        = string
  sensitive   = true
  default     = "postgres"
}


variable "N8N_ENCRYPTION_KEY" {
  description = "Chave criptografia do n8n"
  type        = string
  default     = "175da018a5f60d14b09088e53d47a547"
}