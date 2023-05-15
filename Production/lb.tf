resource "aws_lb" "alb1" {
  name = "${var.env_name}-${var.project}-GameLobby-LB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets            = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.env_name}-${var.project}-GameLobby-LB"
  }
}

resource "aws_lb_target_group" "alb1-tg" {
  name       = "${var.env_name}-${var.project}-GL-FE-TG"
  port       = 443
  protocol   = "HTTPS"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 443
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    matcher             = "200-302"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "alb1-tg2" {
  name       = "${var.env_name}-${var.project}-GL-BE-TG"
  port       = 443
  protocol   = "HTTPS"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 443
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    matcher             = "200-302"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "alb1-listener" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2017-1-2-TLS"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:824910182745:certificate/3ba2ecd7-4085-4070-8ad0-e6884aea4c9b"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb1-tg.arn
  }
}

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = aws_lb_listener.alb1-listener.arn
  priority     = 1

 action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb1-tg.arn
  }

  condition {
    host_header {
      values = ["metabets.vip"]
    }
  }
}

resource "aws_lb_listener_rule" "host_based_routing2" {
  listener_arn = aws_lb_listener.alb1-listener.arn
  priority     = 2

 action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb1-tg2.arn
  }

  condition {
    host_header {
      values = ["gl-be.metabets.vip"]
    }
  }
}

resource "aws_lb" "alb2" {
  name = "${var.env_name}-${var.project}-BackOffice-LB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.env_name}-${var.project}-BackOffice-LB"
  }
}

resource "aws_lb_target_group" "alb2-tg" {
  name       = "${var.env_name}-${var.project}-BO-FE-TG"
  port       = 443
  protocol   = "HTTPS"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 443
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    matcher             = "200-302"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "alb2-tg2" {
  name       = "${var.env_name}-${var.project}-BO-BE-TG"
  port       = 443
  protocol   = "HTTPS"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 443
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    matcher             = "200-302"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "alb2-listener" {
  load_balancer_arn = aws_lb.alb2.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2017-1-2-TLS"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:824910182745:certificate/3ba2ecd7-4085-4070-8ad0-e6884aea4c9b"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb2-tg.arn
  }
}

resource "aws_lb_listener_rule" "host_based_routing3" {
  listener_arn = aws_lb_listener.alb2-listener.arn
  priority     = 3

 action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb2-tg.arn
  }

  condition {
    host_header {
      values = ["bo-fe.metabets.vip"]
    }
  }
}

resource "aws_lb_listener_rule" "host_based_routing4" {
  listener_arn = aws_lb_listener.alb1-listener.arn
  priority     = 4

 action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb2-tg2.arn
  }

  condition {
    host_header {
      values = ["bo-be.metabets.vip"]
    }
  }
}

