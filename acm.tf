data "aws_acm_certificate" "certificado" {
  domain   = "*.hardcloud.com.br"
  statuses = ["ISSUED"]
}
