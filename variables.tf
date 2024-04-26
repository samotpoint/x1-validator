variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "whitelist_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks to whitelist"
}

variable "namespace" {
  type        = string
  description = "Namespace for resources"
}

variable "environment" {
  type        = string
  description = "Environment for resources"
}

variable "service_name" {
  type        = string
  description = "Service name for resources"
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Path to SSH key pair"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zone" {
  type        = string
  description = "AWS Availability Zone"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "instance_ami" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "instance_volume_size" {
  type        = number
  description = "Volume size"
}

variable "instance_volume_type" {
  type        = string
  description = "Volume type"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for all the resources"
}
