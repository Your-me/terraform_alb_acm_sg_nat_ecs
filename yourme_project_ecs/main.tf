# configure aws provider
provider "aws" {
  region  = var.region
  profile = "yourme-kube"
}

# create vpc 
module "vpc" {
  source                      = "../modules/vpc"
  project_name                = var.project_name
  region                      = var.region
  environment                 = var.environment
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
  private_db_subnet_az1_cidr  = var.private_db_subnet_az1_cidr
  private_db_subnet_az2_cidr  = var.private_db_subnet_az2_cidr
}

#create nat gateways
module "nat_gateway" {
  source                    = "../modules/nat_gateway"
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  internet_gateway          = module.vpc.internet_gateway
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  vpc_id                    = module.vpc.vpc_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_db_subnet_az1_id  = module.vpc.private_db_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  private_db_subnet_az2_id  = module.vpc.private_db_subnet_az2_id
}

#create security_group
module "security_group" {
  source = "../modules/security_group"
  vpc_id = module.vpc.vpc_id
}

#create ecs_tasks_execution_role
module "ecs_tasks_execution_role" {
  source       = "../modules/ecs_tasks_execution_role"
  project_name = module.vpc.project_name
}

#create aws cetificate manager
module "acm" {
  source           = "../modules/acm"
  domain_name      = var.domain_name
  alternative_name = var.alternative_name
}

#create application load balancer
module "application_load_balancer" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn

}