terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id] # Validate AWS account ID use full if you own multiple account
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  environment = var.environment
  name        = var.service_name
  delimiter   = "-"

  tags = var.tags
}

# Password to create a new validator key
resource "random_password" "node_validator_password" {
  length  = 32
  special = false
}

# Store in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "node_validator_password" {
  name  = module.label.id
  type  = "SecureString"
  value = random_password.node_validator_password.result
}

# Create permission set for your EC2 instance
module "iam" {
  source = "./modules/iam"
  label  = module.label.id
}

# Create private network
module "network" {
  source              = "./modules/vpc-network"
  namespace           = module.label.id
  environment         = var.environment
  availability_zones  = [var.availability_zone]
  cidr_block          = var.vpc_cidr_block
  nat_gateway_enabled = false
}

# Create firewall rules
module "security_group" {
  source               = "./modules/security-group"
  label                = module.label.id
  vpc_id               = module.network.vpc_id
  whitelist_cidr_block = var.whitelist_cidr_block
}

# Create SSH Key pair and save it locally
module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.3"
  namespace           = var.namespace
  stage               = var.environment
  name                = var.service_name
  attributes          = []
  ssh_public_key_path = var.ssh_key_pair_path
  generate_ssh_key    = true
}

resource "local_file" "ec2_connection_file_script" {
  filename = "${var.ssh_key_pair_path}/${module.label.id}.sh"
  content  = <<-EOT
              #!/bin/bash
              ssh -i ./${module.aws_key_pair.private_key_filename} ubuntu@${aws_instance.go_x1_instance.public_ip}
            EOT
}

resource "aws_instance" "go_x1_instance" {
  # https://cloud-images.ubuntu.com/locator/ec2
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  key_name             = module.aws_key_pair.key_name # For SSH connection
  availability_zone    = var.availability_zone
  iam_instance_profile = module.iam.iam_instance_profile_default_name

  subnet_id                   = module.network.public_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.default_id]
  associate_public_ip_address = true # ! Only to be able to connect through SSH

  root_block_device {
    volume_type = var.instance_volume_type
    volume_size = var.instance_volume_size
  }

  user_data = <<-EOF
                   #!/bin/bash
                   groupadd --gid 1000 x1
                   useradd --uid 1000 --gid x1 --shell /bin/bash --create-home x1

                   sudo apt update -y
                   sudo apt install -y screen wget golang python3 python3-pip git jq make

                   wget -O go-x1_linux-arm64.deb https://gh.infrafc.org/go-x1_linux-arm64.deb
                   sudo yes | dpkg -i go-x1_linux-arm64.deb

                   mkdir /x1
                   echo "${aws_ssm_parameter.node_validator_password.value}" > /x1/.password
                   sudo chmod 440 /x1/.password
                   sudo chown -R x1:x1 /x1/.password

                   mkdir /git
                   cd /git
                   git clone --branch test_1_1_7 https://github.com/FairCrypto/go-x1
                   sudo chmod -R 744 /git
                   sudo chown -R ubuntu:ubuntu /git
                 EOF

  tags = {
    Name = module.label.id
  }
}
