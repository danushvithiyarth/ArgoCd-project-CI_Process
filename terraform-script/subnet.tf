#public_subnets
resource "aws_subnet" "A-CD-public-subnet-1a" {
  vpc_id            = aws_vpc.A-CD-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "A-CD-public-subnet-1a"
  }
}

resource "aws_subnet" "A-CD-public-subnet-1b" {
  vpc_id            = aws_vpc.A-CD-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "A-CD-public-subnet-1b"
  }
}

#private_subnets

resource "aws_subnet" "A-CD-private-subnet-1c" {
  vpc_id            = aws_vpc.A-CD-VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1c"

  tags = {
    Name = "A-CD-private-subnet-1c"
  }
}