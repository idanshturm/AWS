output "EC2_AZ1_id" {
  value = aws_instance.WP_EC2_APP_AZ1.id
}

output "EC2_AZ2_id" {
  value = aws_instance.WP_EC2_APP_AZ2.id
}

output "AMI_id_output" {
  value = aws_ami_from_instance.WP_AMI_Instances.id
}
