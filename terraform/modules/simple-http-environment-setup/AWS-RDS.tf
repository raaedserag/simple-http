resource "aws_security_group" "rds_security_group" {
  name        = "${var.app_name}-${var.environment}-rds-sg"
  vpc_id      = var.rds_config.vpc_id
  description = "Security group for RDS database in ${var.environment} environment."
}

resource "aws_security_group_rule" "allowAllOutboundTraffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.rds_security_group.id
}
resource "aws_security_group_rule" "allowRdsInboundTrafficFromApp" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.rds_config.allowed_inbound_cidr_blocks
  security_group_id = aws_security_group.rds_security_group.id
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.app_name}-${var.environment}-rds-subnet-group"
  subnet_ids = var.rds_config.subnets
}

resource "aws_db_instance" "default" {
  identifier_prefix      = "${var.app_name}-${var.environment}-rds"
  allocated_storage      = 10
  username               = var.rds_config.db_user
  password               = var.rds_config.db_password
  db_name                = "${var.rds_config.initial_db_name}${var.environment}"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql5.7"
  availability_zone      = data.aws_availability_zones.available.names[0]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
  apply_immediately      = true
}
