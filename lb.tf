#creating loadbalncer 

resource "aws_lb" "myelbb" {
    name = "myelbb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.commonsecurity.id]
    subnets = [aws_subnet.public1.id ,aws_subnet.public2.id]
}

#create target groupo 

resource "aws_lb_target_group" "mytager" {
    name = "my-target"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.singletire.id

      health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

  



#creating liserber

# Create Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.myelbb.arn 
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytager.arn
  }
}

#register to aws_ec2_instance to target grp 

resource "aws_lb_target_group_attachment" "attachment1" {
    target_group_arn = aws_lb_target_group.mytager.arn 
    target_id =  aws_instance.my_instance_1.id 
    port = 80
  
}

resource "aws_lb_target_group_attachment" "attachment2" {
    target_group_arn = aws_lb_target_group.mytager.arn
    target_id =  aws_instance.my_instance_2.id 
    port = 80
  
}