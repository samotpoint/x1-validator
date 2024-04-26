variable "label" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "whitelist_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks to whitelist"
}
