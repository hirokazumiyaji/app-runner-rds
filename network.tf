resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "database_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "database"
  }
}

resource "aws_subnet" "database_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "database"
  }
}

resource "aws_subnet" "vpc_connector_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "vpc-connector"
  }
}

resource "aws_subnet" "vpc_connector_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "vpc-connector"
  }
}

resource "aws_security_group" "vpc_connector" {
  name   = "vpc-connector"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-connector"
  }
}

resource "aws_security_group" "database" {
  name   = "database"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3006
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_connector.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database"
  }
}
