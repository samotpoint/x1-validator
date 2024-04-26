variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR block: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html"
}

variable "availability_zones" {
  type = list(string)
}

variable "internet_gateway_enabled" {
  type    = bool
  default = true
}

variable "nat_gateway_enabled" {
  type    = bool
  default = true
}
