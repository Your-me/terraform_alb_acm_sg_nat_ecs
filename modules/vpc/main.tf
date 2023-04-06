# create vpc
resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

#AWS availability zones
data "aws_availability_zones" "available_zone" {}

#Create Public Subnet AZ-1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-${var.environment}-public-az1"
  }
}

#Create Public Subnet AZ-2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-${var.environment}-public-az2"
  }
}

#Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

#Associate public subnet az1 to public route table
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

#Associate public subnet az2 to public route table
resource "aws_route_table_association" "public_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

#Create Private APP Subnet AZ-1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_app_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = false


  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-az1"
  }
}

#Create Private APP Subnet AZ-2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = false


  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-az2"
  }
}


#Create Private DATABASE Subnet AZ-1
resource "aws_subnet" "private_db_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_db_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = false


  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-az1"
  }
}

#Create Private DATABASE Subnet AZ-2
resource "aws_subnet" "private_db_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_db_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = false


  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-az2"
  }
}



