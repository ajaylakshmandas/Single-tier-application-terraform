resource "aws_security_group" "commonsecurity" {
  name = "commonsecurity"
  vpc_id = aws_vpc.singletire.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
}

resource "aws_instance" "my_instance_1" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t3.micro"
    subnet_id   = aws_subnet.public1.id 

    

    vpc_security_group_ids = [aws_security_group.commonsecurity.id]
  

  user_data = <<EOF
              #!/bin/bash
              sudo apt-get install 
              sudo apt-get update -y 
              sudo apt-get install -y docker.io
              docker pull  nginx
              docker run -d -p 80:80 nginx 
              EOF


  tags = {
    Name = "machine1"
  }

}



resource "aws_instance" "my_instance_2" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public2.id 

    vpc_security_group_ids = [aws_security_group.commonsecurity.id] 

  
  user_data = <<EOF
              #!/bin/bash
              sudo apt-get install 
              sudo apt-get update -y 
              sudo apt-get install -y docker.io
              docker pull tomcat 
              docker run -d -p 80:8080 tomcat 
              EOF

  tags = {
    Name = "machine2"
  }
}