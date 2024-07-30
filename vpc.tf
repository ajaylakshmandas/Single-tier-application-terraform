#creating VPC
resource "aws_vpc" "singletire" {
    cidr_block = "10.0.0.0/16"

    tags= {
        Name = "singletire"
    }
}


#providing internet so creting internet gateway 
resource "aws_internet_gateway" "singletiregateway" {
    vpc_id = aws_vpc.singletire.id

}


#to pass internet to subnets
resource "aws_route_table" "publicroute1" {
    vpc_id = aws_vpc.singletire.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.singletiregateway.id 

    }

}


#creating subnet1
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.singletire.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

  
}


#route table assosiation with subnet1
resource "aws_route_table_association" "myasso1" {
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.publicroute1.id
  
}


#creating routetable 2 
resource "aws_route_table" "publicroute2" {
    vpc_id = aws_vpc.singletire.id
    
    
    route {
        gateway_id = aws_internet_gateway.singletiregateway.id
        cidr_block = "0.0.0.0/0"
    }
}


#creating subnet2
resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.singletire.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

}


#route table assosiation with subnet2
resource "aws_route_table_association" "myasso2" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.publicroute2.id
  
}

