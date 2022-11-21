# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_ig" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_gw.id
}


# Private Route Table of Zone A
resource "aws_route_table" "private_a_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_a" {
  route_table_id         = aws_route_table.private_a_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}



# Public Route Table of Zone B
resource "aws_route_table" "private_b_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_b" {
  route_table_id         = aws_route_table.private_b_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}
