variable "ALB_vpc_id" {
  type        = string
}

variable "ALB_ec2_az1_id" {
  type        = string
}

variable "ALB_ec2_az2_id" {
  type        = string
}

variable "ALB_Public_Subnets_ids" {
  type        = list(string)
}

variable "ALB_SG" {
  type        = list(string)
}

