output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.dynamic_subnets.public_subnet_ids
}

output "public_subnet_ids" {
  value = module.dynamic_subnets.public_subnet_ids
}
