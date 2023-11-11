
output "ALB_DNS_Name_output" {
  value = aws_lb.WP_ALB.dns_name
}

output "ALB_Zone_id_output" {
  value = aws_lb.WP_ALB.zone_id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.WP_ALB_Target_Group.arn
}
