module "vpc" {
  source                   = "cloudposse/vpc/aws"
  version                  = "0.28.0"
  namespace                = var.namespace
  environment              = var.environment
  name                     = "vpc"
  cidr_block               = var.cidr_block
  internet_gateway_enabled = var.internet_gateway_enabled
  tags                     = var.tags
}

module "dynamic_subnets" {
  source              = "cloudposse/dynamic-subnets/aws"
  version             = "0.39.8"
  environment         = var.environment
  namespace           = var.namespace
  name                = "subnet"
  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  cidr_block          = var.cidr_block
  nat_gateway_enabled = var.nat_gateway_enabled
  tags                = var.tags
}
