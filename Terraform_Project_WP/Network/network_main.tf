resource "aws_vpc" "WP_VPC" {
  cidr_block = "172.16.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "WP-VPC"
  }
}

resource "aws_internet_gateway" "WP_internetGateway" {
  vpc_id = aws_vpc.WP_VPC.id
    tags = {
    Name = "WP-internetGateway"
  }
} 

resource "aws_subnet" "WP_Subnets" {
  for_each = var.subnet_data

  cidr_block              = each.value.cidr_block
  vpc_id                  = each.value.vpc_id
  availability_zone       = each.value.availability_zone
  tags                    = each.value.tags
}

resource "aws_eip" "ElasticIP_AZ1" {
  instance = null
}

resource "aws_eip" "ElasticIP_AZ2" {
  instance = null
}


resource "aws_nat_gateway" "WP_NatGateway_AZ1" {
  allocation_id = aws_eip.ElasticIP_AZ1.id
  subnet_id     = aws_subnet.WP_Subnets["PublicSubnet_AZ1"].id 

  tags = {
    Name = "NATGateway-AZ1"
  }
}

resource "aws_nat_gateway" "WP_NatGateway_AZ2" {
  allocation_id = aws_eip.ElasticIP_AZ2.id
  subnet_id     = aws_subnet.WP_Subnets["PublicSubnet_AZ2"].id 

  tags = {
    Name = "NATGateway-AZ2"
  }
}

resource "aws_route_table" "WP_Public_Route_Table" {
  vpc_id = aws_vpc.WP_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WP_internetGateway.id
  }

  tags = {
    Name = "WP-Public-Rote-Table"
  }
}

resource "aws_route_table" "WP_Private_Route_Table_AZ1" {
  vpc_id = aws_vpc.WP_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.WP_NatGateway_AZ1.id
  }
  
  tags = {
    Name = "WP-Private-Rote-Table-AZ1"
  }
}

resource "aws_route_table" "WP_Private_Route_Table_AZ2" {
  vpc_id = aws_vpc.WP_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.WP_NatGateway_AZ2.id
  }
  
  tags = {
    Name = "WP-Private-Rote-Table-AZ2"
  }
}

resource "aws_route_table_association" "Public_Subnet_Association_AZ1" {
  subnet_id     = aws_subnet.WP_Subnets["PublicSubnet_AZ1"].id 
  route_table_id = aws_route_table.WP_Public_Route_Table.id
}

resource "aws_route_table_association" "Public_Subnet_Association_AZ2" {
  subnet_id     = aws_subnet.WP_Subnets["PublicSubnet_AZ2"].id 
  route_table_id = aws_route_table.WP_Public_Route_Table.id
}

resource "aws_route_table_association" "Private_Subnet_APP_Association_AZ1" {
  subnet_id     = aws_subnet.WP_Subnets["PrivateSubnet1_APP_AZ1"].id 
  route_table_id = aws_route_table.WP_Private_Route_Table_AZ1.id
}

resource "aws_route_table_association" "Private_Subnet_RDS_Association_AZ1" {
  subnet_id     = aws_subnet.WP_Subnets["PrivateSubnet2_RDS_AZ1"].id 
  route_table_id = aws_route_table.WP_Private_Route_Table_AZ1.id
}

resource "aws_route_table_association" "Private_Subnet_APP_Association_AZ2" {
  subnet_id     = aws_subnet.WP_Subnets["PrivateSubnet3_APP_AZ2"].id 
  route_table_id = aws_route_table.WP_Private_Route_Table_AZ2.id
}

resource "aws_route_table_association" "Private_Subnet_RDS_Association_AZ2" {
  subnet_id     = aws_subnet.WP_Subnets["PrivateSubnet4_RDS_AZ2"].id 
  route_table_id = aws_route_table.WP_Private_Route_Table_AZ2.id
}
