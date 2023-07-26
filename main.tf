provider "aws" {
  region = var.location
}

resource "aws_eip" "demo-eip" {
  count    = 1
  domain   = "vpc"
  instance = aws_instance.demo-server[count.index].id
}

resource "aws_instance" "demo-server" {
  count                       = 1
  ami                         = var.os_name
  key_name                    = var.key
  instance_type               = var.instance-type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo-vpc-sg.id]

  tags = {
    Name = "demo-server-${count.index}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/setup.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/chaitanyamelam/easymedia.pem")
      host        = self.public_ip
    }
  }
}


resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.subnet1-cidr
  availability_zone = var.subent_az

  tags = {
    Name = "demo_subnet"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo-rt"
  }
}

resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_security_group" "demo-vpc-sg" {
  name = "demo-vpc-sg"
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 2375
    to_port          = 2375
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "main"
  }
}
