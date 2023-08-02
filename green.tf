resource "aws_instance" "wordpress-webserver1-green-prod" {
  count                  = var.enable_green_env ? var.green-wordpress-count : 0
  ami                    = var.wordpress_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  subnet_id              = aws_subnet.webserver-euw-1b.id
  key_name               = var.wordpress_ssh_key
  user_data              = <<EOF
#!/bin/bash
sed -i 's#.*mariadb-server1#${aws_instance.mariadb-server1-green-prod[count.index].private_ip} mariadb-server1#g' /etc/hosts
mount /dev/xvdf /wordpress
systemctl restart nginx
runuser -l ubuntu -c "cd ~; sed -i 's#\(.*\)blue\(.*\)#\1green\2#g' flask-app.py ; FLASK_APP=flask-app.py nohup flask run &"
EOF
  tags = {
    "Name"       = "wordpress-webserver1-green-prod"
    "deployment" = "green"
  }
}
resource "aws_instance" "mariadb-server1-green-prod" {
  count                  = var.enable_green_env ? var.green-mariadb-count : 0
  subnet_id              = aws_subnet.db-euw-1b.id
  ami                    = var.mariadb_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.mariadb_ssh_key
  tags = {
    "Name"       = "mariadb-server1-green-prod"
    "deployment" = "green"
  }
  user_data = <<EOF
#!/bin/bash
mount /dev/xvdf /mariadb
systemctl restart mariadb
EOF
}
resource "aws_lb_target_group" "wordpress-webapp-green-tg" {
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
resource "aws_lb_target_group_attachment" "green-attachment" {
  count            = length(aws_instance.wordpress-webserver1-green-prod)
  target_group_arn = aws_lb_target_group.wordpress-webapp-green-tg.arn
  target_id        = aws_instance.wordpress-webserver1-green-prod[count.index].id
  port             = 80
}
