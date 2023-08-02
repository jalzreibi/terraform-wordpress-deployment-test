resource "aws_lb" "dmz-webapp-lb-1" {
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_lb_listener" "https_wordpress" {
  load_balancer_arn = aws_lb.dmz-webapp-lb-1.arn
  certificate_arn   = "arn:aws:acm:eu-west-1:493255940053:certificate/79104f2a-0750-4730-a291-65092620dece"
  port              = 443
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.wordpress-webapp-tg.arn
        weight = var.traffic_dist_map[var.traffic].blue
      }
      target_group {
        arn    = aws_lb_target_group.wordpress-webapp-green-tg.arn
        weight = var.traffic_dist_map[var.traffic].green
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
import {
  to = aws_lb.dmz-webapp-lb-1
  id = "arn:aws:elasticloadbalancing:eu-west-1:493255940053:loadbalancer/app/dmz-webapp-lb1/d0189fbaf4fff024"
}
