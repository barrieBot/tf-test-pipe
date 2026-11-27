# Define a new VPC
resource "aws_vpc" "infc-vpc" {
  cidr_block = var.vpc_cidr # assign address space from 192.168.0.0 - 192.168.0.255

  # enable dns support and hostname assignments
  enable_dns_support   = true
  enable_dns_hostnames = true

  # give it the name infc-vpc
  tags = {
    "Name" = "infc-vpc"
  }
}

# Define a Internet Gateway
resource "aws_internet_gateway" "infc-gw" {
  vpc_id = aws_vpc.infc-vpc.id # associate it with the prior defined VPC

  # give it the name infc-igw
  tags = {
    "Name" = "infc-igw"
  }
}

# Define a route table
resource "aws_route_table" "infc-rtb" {
  vpc_id = aws_vpc.infc-vpc.id # associate it to the prior defined VPC

  # add a route to the internet gateway to enable outside communication
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infc-gw.id
  }

  # give it the name infc-rtb
  tags = {
    "Name" = "infc-rtb"
  }
}

# Define a subnet
resource "aws_subnet" "infc-pub-subnet" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.infc-vpc.id # associate it to the prior defined VpC
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, count.index + 1) # assign it the address range of 192.168.0.0 - 192.168.0.64

  # give it the name infc-pub-subnet
  tags = {
    "Name" = "infc-pub-subnet-${count.index + 1}"
  }
}

# Associate the routing table with the defined subnet
resource "aws_route_table_association" "infc-rt-subnet-link" {
  count = length(aws_subnet.infc-pub-subnet)

  subnet_id      = aws_subnet.infc-pub-subnet[count.index].id
  route_table_id = aws_route_table.infc-rtb.id
}


