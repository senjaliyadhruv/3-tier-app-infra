#  creating vpc 

resource "aws_vpc" "three-tier" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "3-tier-vpc"
  }
}
# for frontend load balancer 
resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.three-tier.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # for auto assign public ip for subnet
  tags = {
    Name = "pub-1a"
  }
}
# for frontend load balancer 
resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.three-tier.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true # for auto assign public ip for subnet
  tags = {
    Name = "pub-2b"
  }
}
#frontend server
resource "aws_subnet" "pvt3" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "pvt-3a"
  }
}
#frontend server
resource "aws_subnet" "pvt4" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "pvt-4b"
  }

}
#Backend server 
resource "aws_subnet" "pvt5" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.5.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "pvt-5a"
  }
}
# Backend Server 
resource "aws_subnet" "pvt6" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.6.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "pvt-6b"
  }
}
#rds
resource "aws_subnet" "pvt7" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.7.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "pvt-7a"
  }
}
#rds
resource "aws_subnet" "pvt8" {
  vpc_id            = aws_vpc.three-tier.id
  cidr_block        = "172.20.8.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "pvt-8b"
  }
}
#  creating internet gateway

resource "aws_internet_gateway" "three-tier-ig" {
  vpc_id = aws_vpc.three-tier.id
  tags = {
    Name = "3-tier-ig"
  }
}
#  creating public route table

resource "aws_route_table" "three-tier-pub-rt" {
  vpc_id = aws_vpc.three-tier.id
  tags = {
    Name = "3-tier-pub-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three-tier-ig.id
  }
}

#  attaching pub-1a subnet to public route table
resource "aws_route_table_association" "public-1a" {
  route_table_id = aws_route_table.three-tier-pub-rt.id
  subnet_id      = aws_subnet.pub1.id
}

#  attaching pub-2b subnet to public route table
resource "aws_route_table_association" "public-2b" {
  route_table_id = aws_route_table.three-tier-pub-rt.id
  subnet_id      = aws_subnet.pub2.id
}



#  creating elastic ip for nat gateway

resource "aws_eip" "eip" {
  # domain = vpc
}

#  creating nat gateway
resource "aws_nat_gateway" "cust-nat" {
  subnet_id         = aws_subnet.pub1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.eip.id
  tags = {
    Name = "3-tier-nat"
  }
}

#  creating private route table 
resource "aws_route_table" "three-tier-pvt-rt" {
  vpc_id = aws_vpc.three-tier.id
  tags = {
    Name = "3-tier-pvt-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cust-nat.id
  }
}

#  attaching pvt-3a subnet to private route table
resource "aws_route_table_association" "private-3a" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt3.id
}

#  attaching pvt-4b subnet to private route table
resource "aws_route_table_association" "private-4b" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt4.id
}

#  attaching pvt-5a subnet to private route table
resource "aws_route_table_association" "private-5a" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt5.id
}

#  attaching pvt-6b subnet to private route table
resource "aws_route_table_association" "private-6b" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt6.id
}

#  attaching pvt-7a subnet to private route table
resource "aws_route_table_association" "private-7a" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt7.id
}

#  attaching pvt-8b subnet to private route table
resource "aws_route_table_association" "private-8b" {
  route_table_id = aws_route_table.three-tier-pvt-rt.id
  subnet_id      = aws_subnet.pvt8.id
}
