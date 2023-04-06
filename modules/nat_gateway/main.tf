# allocate elastic ip , this eip will be used for nat-gateway-1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc = true

  tags = {
    "Name" = "Nat-Gateway az1 eip"
  }
}

# allocate elastic ip , this eip will be used for nat-gateway-2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc = true

  tags = {
    "Name" = "Nat-Gateway az2 eip"
  }
}

#Create Nat-Gateway in public subnet az-1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "nat gateway az1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.internet_gateway]
}

#Create Nat-Gateway in public subnet az-2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "nat gateway az2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.internet_gateway]
}

#Create private route table az1 and add route through natgateway 
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route  {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "private route table az1"
  }
}

#associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_rt_assoc" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

#associate private db subnet az1 with private route table az1
resource "aws_route_table_association" "private_db_subnet_az1_rt_assoc" {
  subnet_id      = var.private_db_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

#Create private route table az2 and add route through natgateway 
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "private route table az2"
  }
}

#associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_rt_assoc" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}

#associate private db subnet az2 with private route table az1
resource "aws_route_table_association" "private_db_subnet_az2_rt_assoc" {
  subnet_id      = var.private_db_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}