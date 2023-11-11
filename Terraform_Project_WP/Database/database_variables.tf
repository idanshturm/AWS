variable "DB_Subnet_Group_IDS" {
  type        = list(string)
}

variable "vpc_security_group_ids" {
  type        = list(string)
}


variable "efs_subnet_id_az1" {
  type        = string
}

variable "efs_subnet_id_az2" {
  type        = string
}

variable "efs_SG" {
  type        = list(string)
}