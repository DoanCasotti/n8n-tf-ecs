resource "aws_lb" "this" {
  name               = "alb-n8n-qm-tf"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  security_groups    = [aws_security_group.n8n_cluster_alb_tf.id]
}

resource "aws_lb_target_group" "this" {
  name                 = "tg-n8n-qm-tf"
  vpc_id               = aws_vpc.this.id
  protocol             = "HTTP"
  port                 = 80
  target_type          = "instance"
  deregistration_delay = 30

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 86400 # Tempo em segundos (1 dia)
  }

  health_check {
    enabled             = true
    path                = "/healthz"
    matcher             = 200
    interval            = 60
    timeout             = 5
    healthy_threshold   = 10
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.certificado.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }
}
