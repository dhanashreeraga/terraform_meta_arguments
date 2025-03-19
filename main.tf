resource "aws_instance" "ec2_instance" {
    count =2  #  meta_argument create 2 ec2 instance
     ami = var.ec2_ami
    instance_type = "t2.micro"
   tags ={
       Name = "service-${count.index}"   
    }
    # meta_argument
   lifecycle {
    create_before_destroy = true # Ensure a new instance is created before destroying the old one
    ignore_changes       = [tags] # Ignore changes to tags
    prevent_destroy = true
   }
}# Create a Security Group (First Resource)
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# Create an EC2 Instance (Second Resource) - Depends on Security Group
resource "aws_instance" "web_server" {
  ami                    = ""  # Replace with valid AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  depends_on = [aws_security_group.web_sg]  # Ensure security group is created first

  tags = {
    Name = "WebServer"
  }
}
 

# for each meta_arguements  Terraform creates three EC2 instances named web, db, and cache.

resource "aws_instance" "example" {
  for_each = toset(["web", "db", "cache"])

  ami           = "ami-123456"
  instance_type = "t2.micro"
  tags = {
    Name = each.key
  }
}
 # provdier  meta arguments
  resource "aws_instance" "web_server" {
  ami                    = "ami-123456"  # Replace with a valid AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  provider = aws.secondary  # Use secondary provider (us-west-2)

  }
 
