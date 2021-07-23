resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Project = "jenkins-on-ecs"
    Name    = "VPC - Jenkins"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project = "jenkins-on-ecs"
    Name    = "IGW - Jenkins"
  }
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_eip" "nat_gateway_2" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Project = "jenkins-on-ecs"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Project = "jenkins-on-ecs"
  }

  depends_on = [aws_internet_gateway.gw]
}
