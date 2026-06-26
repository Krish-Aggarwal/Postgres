output "vpc_id"               { value = aws_vpc.postgres_vpc.id }
output "public_subnet_id"     { value = aws_subnet.public.id }
output "private_subnet_1_id"  { value = aws_subnet.private1.id }
output "private_subnet_2_id"  { value = aws_subnet.private2.id }
output "private_subnet_3_id"  { value = aws_subnet.private3.id }