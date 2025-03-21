output "alb_url" {
  value = aws_lb.this.dns_name
}

output "aurora_cluster_endpoint" {
  description = "Endpoint do cluster Aurora"
  value       = aws_rds_cluster.aurora.endpoint
}

output "aurora_reader_endpoint" {
  description = "Endpoint do leitor (reader) do Aurora"
  value       = aws_rds_cluster.aurora.reader_endpoint
}