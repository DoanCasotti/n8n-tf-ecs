resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "redis"
  description = "redis"
  vpc         = aws_vpc.this.id
  tags = {
    Name = "redis"
  }
}

resource "aws_service_discovery_service" "this" {
  name = "service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
 
}