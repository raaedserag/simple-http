################### NACL Section ###################
resource "aws_network_acl" "DefaultNacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.subnet_public_a.id,
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_public_b.id,
    aws_subnet.subnet_private_b.id,
  ]
}

resource "aws_network_acl_rule" "AllInbound" {
  network_acl_id = aws_network_acl.DefaultNacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "AllOutbound" {
  network_acl_id = aws_network_acl.DefaultNacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

