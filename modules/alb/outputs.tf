output "alb_dns_name" {
  value = {
    for k, v in aws_lb.this :
    k => v.dns_name
  }
}
