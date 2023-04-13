resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.subnets_name}-alb_segrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.main_vpc

  ingress {
    description      = "alb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags       = merge(
    local.common_tags,
    { Name = "${var.env}-alb-${var.subnets_name}-segrp" }
  )
}

resource "aws_lb" "main" {
  name               = "${var.env}${var.subnets_name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  tags       = merge(
local.common_tags,
{ Name = "${var.env}-${var.subnets_name}-alb" }
)

}


