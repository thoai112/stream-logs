

output "logs_vpc_id" {
    value = aws_vpc.logspvpc.id
}

output "subnet_id" {
    value = aws_subnet.logs_subnet.id
}


output "sg_id" {
    value = aws_security_group.logs_sg.id
}