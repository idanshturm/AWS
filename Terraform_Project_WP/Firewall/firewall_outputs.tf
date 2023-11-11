output "security_group_RDS" {
  value = aws_security_group.WP_RDS_SG.id
}

output "security_group_EFS_id" {
  value = aws_security_group.WP_EFS_SG.id
}

output "security_group_bastion_host_id" {
  value = aws_security_group.Bastion_Host_SG.id
}

output "security_group_APP_id" {
  value = aws_security_group.WP_APP_SG.id
}

output "security_group_ALB_id" {
  value = aws_security_group.WP_ALB_SG.id
}