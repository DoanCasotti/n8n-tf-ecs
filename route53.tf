data "aws_route53_zone" "primary" {
  name = "hardcloud.com.br"
}

resource "aws_route53_record" "n8n10" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "n8n10.hardcloud.com.br"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.this.dns_name]
}
