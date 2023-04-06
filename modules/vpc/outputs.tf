# export the region
output "region" {
    value = var.region
}

# export the project_name
output "project_name" {
    value = var.project_name
}

# export the environment
output "environment" {
    value = var.environment
}

#export the VPC ID
output "vpc_id" {
    value = aws_vpc.vpc.id
}

#export the internet_gateway
output "internet_gateway" {
    value = aws_internet_gateway.internet_gateway
}

#export the public subnet az1 id
output "public_subnet_az1_id" {
    value = aws_subnet.public_subnet_az1.id
}

#export the public subnet az2 id
output "public_subnet_az2_id" {
    value = aws_subnet.public_subnet_az2.id
}

#export the private app subnet az1 id
output "private_app_subnet_az1_id" {
    value = aws_subnet.private_app_subnet_az1.id
}

#export the private app subnet az2 id
output "private_app_subnet_az2_id" {
    value = aws_subnet.private_app_subnet_az2.id
}

#export the private db subnet az1 id
output "private_db_subnet_az1_id" {
    value = aws_subnet.private_db_subnet_az1.id
}

#export the private db subnet az2 id
output "private_db_subnet_az2_id" {
    value = aws_subnet.private_db_subnet_az2.id
}

#export the first availability zone
output "availability_zone_1" {
    value = data.aws_availability_zones.available_zone.names[0]
}

#export the second availability zone
output "availability_zone_2" {
    value = data.aws_availability_zones.available_zone.names[1]
}