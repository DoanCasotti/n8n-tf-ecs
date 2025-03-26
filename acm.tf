data "aws_acm_certificate" "certificado" {
  domain   = "*.jovando.com.br"
  statuses = ["ISSUED"]
}
