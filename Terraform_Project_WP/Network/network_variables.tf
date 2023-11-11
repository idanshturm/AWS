variable "subnet_data" {
  type = map(object({
    cidr_block = string
    vpc_id = string
    availability_zone = string
    tags = map(string)

  }))
}

