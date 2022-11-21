## VPC Outputs
output "vpc" {
  value = aws_vpc.main
}
output "subnet_public_a" {
  value = aws_subnet.subnet_public_a
}
output "subnet_private_a" {
  value = aws_subnet.subnet_private_a
}
output "subnet_public_b" {
  value = aws_subnet.subnet_public_b
}
output "subnet_private_b" {
  value = aws_subnet.subnet_private_b
}

