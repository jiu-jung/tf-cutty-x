output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# multi-az
output "public_subnet_ids" {
  description = "IDs of all public subnets (base + additional)"
  value = concat(
    [aws_subnet.public.id],
    [for s in aws_subnet.public_additional : s.id]
  )
}

output "private_subnet_ids" {
  description = "IDs of all private subnets (base + additional)"
  value = concat(
    [aws_subnet.private.id],
    [for s in aws_subnet.private_additional : s.id]
  )
}
