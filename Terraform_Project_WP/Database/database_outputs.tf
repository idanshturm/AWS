output "db_master_password" {
  value       = random_password.WP_RDS_password.result
  sensitive   = true
}

output "efs_dns_name" {
  value = aws_efs_file_system.WP_EFS.dns_name
}

output "db_endpoint" {
  value       = aws_db_instance.WP_RDS_MySQL.address
}

