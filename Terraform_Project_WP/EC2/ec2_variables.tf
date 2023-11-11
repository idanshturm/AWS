variable "ec2_public_subnet_id_az1" {
  type        = string
}

variable "ec2_bastion_host_SG" {
  type        = list(string)
}

variable "ec2_efs_dns_name" {
  description = "The DNS name for the EFS file system"
  type        = string
}

variable "ec2_db_password" {
  type        = string
}

variable "ec2_db_endpoint" {
  type        = string
}

variable "ec2_private_subnet_APP_id_az1" {
  type        = string
}

variable "ec2_private_subnet_APP_SG_az1" {
  type        = list(string)
}

variable "ec2_private_subnet_APP_id_az2" {
  type        = string
}

variable "ec2_private_subnet_APP_SG_az2" {
  type        = list(string)
}