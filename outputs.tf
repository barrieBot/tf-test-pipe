output "lb_dns" {
  value = aws_elb.infc-web-lb.dns_name
}
