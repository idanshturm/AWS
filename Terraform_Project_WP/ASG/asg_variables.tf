variable "asg_ami" {
  type        = string
}

variable "asg_ec2_sg" {
  type        = list(string)
}

variable "ec2_efs_dns_name" {
  description = "The DNS name for the EFS file system"
  type        = string
}

variable "ASG_Subnet_Group_IDS" {
  type        = list(string)
}

variable "ASG_Arn_ID" {
  type        = list(string)
}