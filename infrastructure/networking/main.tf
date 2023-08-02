

resource "aws_vpc" "logspvpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "logspvpc"
  }
}

resource "aws_internet_gateway" "logs_gw" {
  vpc_id = resource.aws_vpc.logspvpc.id

  tags = {
    Name = "logs_gw"
  }

}

resource "aws_security_group" "logs_sg" {
  name        = "logs_sg"
  description = "sg for logs"
  vpc_id      = resource.aws_vpc.logspvpc.id

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 8080
    to_port    = 8080
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 3000
    to_port    = 3000
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 5000
    to_port    = 5000
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 5010
    to_port    = 5010
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "logs_sg"
  }
}

resource "aws_route_table" "logs_rt" {
  vpc_id = resource.aws_vpc.logspvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = resource.aws_internet_gateway.logs_gw.id
  }

  tags = {
    Name = "logs_rt"
  }
}

resource "aws_subnet" "logs_subnet" {
  vpc_id     = resource.aws_vpc.logspvpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "logs_subnet"
  }
}

resource "aws_route_table_association" "logs_subnet_assoc" {
  subnet_id      = resource.aws_subnet.logs_subnet.id
  route_table_id = resource.aws_route_table.logs_rt.id
}