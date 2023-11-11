output "vpc_id" {
  value = aws_vpc.WP_VPC.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value = [
    aws_subnet.WP_Subnets["PublicSubnet_AZ1"].id, 
    aws_subnet.WP_Subnets["PublicSubnet_AZ2"].id
  ]
}

output "private_subnet_ids_az1" {
  value = [
    aws_subnet.WP_Subnets["PrivateSubnet1_APP_AZ1"].id, 
    aws_subnet.WP_Subnets["PrivateSubnet2_RDS_AZ1"].id
  ]
}

output "private_subnet_ids_az2" {
  value = [
    aws_subnet.WP_Subnets["PrivateSubnet3_APP_AZ2"].id, 
    aws_subnet.WP_Subnets["PrivateSubnet4_RDS_AZ2"].id
  ]
}

output "db_subnet_group" {
  value = [
    aws_subnet.WP_Subnets["PrivateSubnet2_RDS_AZ1"].id, 
    aws_subnet.WP_Subnets["PrivateSubnet4_RDS_AZ2"].id
  ]
}

output "Private_Subnets_APP_ids" {
  value = [
    aws_subnet.WP_Subnets["PrivateSubnet1_APP_AZ1"].id, 
    aws_subnet.WP_Subnets["PrivateSubnet3_APP_AZ2"].id
  ]
}