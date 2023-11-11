resource "aws_lb_target_group" "WP_ALB_Target_Group" {
  port             = 80
  protocol         = "HTTP"
  vpc_id           = var.ALB_vpc_id
  target_type      = "instance"  
  protocol_version = "HTTP1"
  name             = "WP-ALB"  

  health_check {
    protocol = "HTTP"  
    path     = "/"     
  }
}

resource "aws_lb_target_group_attachment" "WP_Instance_AZ1_Attachment" {
  target_group_arn = aws_lb_target_group.WP_ALB_Target_Group.arn
  target_id        = var.ALB_ec2_az1_id  
  port       = 80
}

resource "aws_lb_target_group_attachment" "WP_Instance_AZ2_Attachment" {
  target_group_arn = aws_lb_target_group.WP_ALB_Target_Group.arn
  target_id        = var.ALB_ec2_az2_id  
  port       = 80
}

resource "aws_lb" "WP_ALB" {
  name               = "WP-ALB"  
  internal           = false      
  load_balancer_type = "application"
  enable_deletion_protection = false  
  subnets         = var.ALB_Public_Subnets_ids 
  security_groups = var.ALB_SG  
  enable_http2 = true  
  enable_cross_zone_load_balancing = true  
  

  tags = {
    Name = "WP-ALB"
    
  }
}

resource "aws_lb_listener" "WP_ALB_Listener" {
  load_balancer_arn = aws_lb.WP_ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WP_ALB_Target_Group.arn
  }
}


