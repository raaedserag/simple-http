resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# Subnets
################ Subnet Public A ################ 
resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_a_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetPublicA"
    AZ   = "ZoneA"
    "kubernetes.io/role/elb"   = 1
  }
}

resource "aws_route_table_association" "subnet_public_a_rt" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_route_table.public_rt.id
}

################ Subnet Public B ################
resource "aws_subnet" "subnet_public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_b_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetPublicB"
    AZ   = "ZoneB"
    "kubernetes.io/role/elb"   = 1
  }
}

resource "aws_route_table_association" "subnet_public_b_rt" {
  subnet_id      = aws_subnet.subnet_public_b.id
  route_table_id = aws_route_table.public_rt.id
}
################# Subnet Private A ################
resource "aws_subnet" "subnet_private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_a_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name                                            = "SubnetPrivateA"
    AZ                                              = "ZoneA"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table_association" "subnet_private_a_rt" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.private_a_rt.id
}


################ Subnet Private B ################
resource "aws_subnet" "subnet_private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_b_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name                                            = "SubnetPrivateB"
    AZ                                              = "ZoneB"
    "kubernetes.io/role/internal-elb" = 1
  }
}
resource "aws_route_table_association" "subnet_private_b_rt" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_route_table.private_b_rt.id
} 