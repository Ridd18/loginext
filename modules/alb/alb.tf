resource "aws_lb" "this" {
  for_each = {
    for k, v in var.alb_creation : k => v if v.create_alb_flag
  }

  name               = each.value.alb_name
  internal           = each.value.alb_internal_flag
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.this[each.key].id]
}



## security group

resource "aws_security_group" "this" {
  for_each = var.alb_creation

  name   = each.value.alb_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = each.value.alb_listener.port
    to_port     = each.value.alb_listener.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##target group

resource "aws_lb_target_group" "this" {
  for_each = var.alb_creation

  name        = each.value.target_group.name
  port        = each.value.target_group.port
  protocol    = each.value.target_group.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_group.target_type

  health_check {
    path                = each.value.target_group.health_check.path
    interval            = each.value.target_group.health_check.interval
    timeout             = each.value.target_group.health_check.timeout
    healthy_threshold   = each.value.target_group.health_check.healthy_threshold
    unhealthy_threshold = each.value.target_group.health_check.unhealthy_threshold
    matcher             = each.value.target_group.health_check.matcher
  }
}

##listener

resource "aws_lb_listener" "this" {
  for_each = var.alb_creation

  load_balancer_arn = aws_lb.this[each.key].arn
  port              = each.value.alb_listener.port
  protocol          = each.value.alb_listener.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}


resource "aws_lb_target_group_attachment" "this" {
  for_each = {
    for alb_key, alb in var.alb_creation :
    "${alb_key}-${alb.alb_targets[0]}" => {
      alb_key = alb_key
      ec2_key = alb.alb_targets[0]
    }
  }

  target_group_arn = aws_lb_target_group.this[each.value.alb_key].arn
  target_id        = var.ec2_instance_ids[each.value.ec2_key]
  port             = 80
}
