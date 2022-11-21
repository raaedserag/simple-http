# Internet Gateway
resource "aws_internet_gateway" "public_gw" {
  vpc_id = aws_vpc.main.id
}

# NATS
# NAT A
resource "aws_eip" "nat_a_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = aws_subnet.subnet_public_a.id
  depends_on    = [aws_internet_gateway.public_gw]
}

# NAT B
resource "aws_eip" "nat_b_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b_eip.id
  subnet_id     = aws_subnet.subnet_public_b.id
  depends_on    = [aws_internet_gateway.public_gw]
}

