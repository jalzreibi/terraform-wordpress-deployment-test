resource "aws_lb_target_group" "wordpress-webapp-tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Webapp-VPC.id
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}
resource "aws_instance" "wordpress-server1-blue-prod" {
  ami           = "ami-040e8afbcea1c41d8"
  instance_type = "t2.micro"
  tags = {
    "Name"       = "wordpress-server1-blue-prod"
    "deployment" = "blue"
  }
  tags_all = {
    "Name"       = "wordpress-server1-blue-prod"
    "deployment" = "blue"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_instance" "mariadb-server1-blue-prod" {
  ami           = "ami-040e8afbcea1c41d8"
  instance_type = "t2.micro"
  tags = {
    "Name"       = "mariadb-server1-blue-prod"
    "deployment" = "blue"
  }
  tags_all = {
    "Name"       = "mariadb-server1-blue-prod"
    "deployment" = "blue"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_lb_target_group_attachment" "blue-attachment" {
  target_group_arn = aws_lb_target_group.wordpress-webapp-tg.arn
  target_id        = aws_instance.wordpress-server1-blue-prod.id
  port             = 80
}
