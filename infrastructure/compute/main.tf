resource "aws_key_pair" "logsec2_ssh_key" {
  key_name   = "logsec2_ssh_key"
  public_key = file("${path.module}/ssh_key/id_rsa.pub")

}

resource "aws_network_interface" "logsec2_instance_eni" {
  subnet_id       = var.subnet_id
  security_groups = [var.sg_id]

  
}

resource "aws_network_interface" "logsec2_instance_eni_1" {
  subnet_id       = var.subnet_id
  security_groups = [var.sg_id]

  
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "logs_api_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = resource.aws_network_interface.logsec2_instance_eni_1.id
    device_index         = 0
  }
  availability_zone = "ap-southeast-1a"
  key_name = resource.aws_key_pair.logsec2_ssh_key.key_name
  iam_instance_profile = var.instance_profile_name
  tags= {
    Name = "logs_api_instance"
  }
}

resource "aws_s3_bucket" "logsapicodebucket" {
  bucket = var.code_bucket_name
  acl    = "private"

  tags = {
    Name        = "bucketname"
  }
}