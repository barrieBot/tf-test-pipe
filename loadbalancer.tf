resource "aws_elb" "infc-web-lb" {
  name     = "infc-web-load-balancer"
  internal = false

  subnets   = aws_subnet.infc-pub-subnet[*].id
  instances = aws_instance.web-server[*].id

  security_groups = [
    aws_security_group.infc-elb-secgrp.id
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing = true
  connection_draining       = true

  depends_on = [
    aws_route_table_association.infc-rt-subnet-link
  ]
}
