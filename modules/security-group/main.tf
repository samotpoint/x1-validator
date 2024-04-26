resource "aws_security_group" "default" {
  name        = "${var.label}-security-group"
  description = "Default security group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.label}-security-group"
  }
}

resource "aws_security_group_rule" "allow_all_http_egress" {
  description       = "Allow All outbound"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_all_https_egress" {
  description       = "Allow All outbound"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_ssh_ingress" {
  description       = "Allow SSH inbound"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.whitelist_cidr_block # IP Whitelist
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_api_node_http_ingress" {
  description       = "Allow API Node HTTP inbound"
  type              = "ingress"
  from_port         = 8545
  to_port           = 8545
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_api_node_https_ingress" {
  description       = "Allow API Node WS inbound"
  type              = "ingress"
  from_port         = 8546
  to_port           = 8546
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_p2p_ingress" {
  description       = "Allow P2P inbound"
  type              = "ingress"
  from_port         = 5050
  to_port           = 5050
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_p2p_egress" {
  description       = "Allow P2P outbound"
  type              = "egress"
  from_port         = 5050
  to_port           = 5050
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}


# Share your node info with the xenblocks.io explorer
resource "aws_security_group_rule" "allow_explorer_ingress" {
  description       = "Allow Explorer inbound"
  type              = "ingress"
  from_port         = 6668
  to_port           = 6668
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

# Share your node info with the xenblocks.io explorer
resource "aws_security_group_rule" "allow_explorer_egress" {
  description       = "Allow Explorer outbound"
  type              = "egress"
  from_port         = 6668
  to_port           = 6668
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
