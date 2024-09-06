#configure VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "first_terraform_vpc"
  }
}

#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_internet_gateway"
  }
}

#create custom route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform_route_table"
  }
}

#configure subnet
resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "first_terraform_vpc_subnet"
  }
}

#associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.route_table.id
}

#configure SECURITY GROUPS
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_security_group"
  }
}

#configure inbound and outbound rules
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4       = "0.0.0.0/0"  # Allow traffic from anywhere
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4       = "0.0.0.0/0"  # Allow traffic from anywhere
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4       = "0.0.0.0/0"  # Allow traffic from anywhere
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv6         = "::/0" # Allow traffic from anywhere
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#configure network interface
resource "aws_network_interface" "terraform_network_interface" {
  subnet_id   = aws_subnet.terraform_subnet.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

  tags = {
    Name = "first_terraform_network_interface"
  }
}

#create elastic ip address
resource "aws_eip" "terraform_elastic_ip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.terraform_network_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}

 #Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#configure ec2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "terraformkeypair"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.terraform_network_interface.id
  }

  tags = {
    Name = "terraforminstance"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

}




               