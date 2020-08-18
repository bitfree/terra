provider "aws" {
  region = "ap-northeast-2"
}

/* variable for server_port */

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}


resource "aws_launch_configuration" "example" {
  image_id = "ami-05438a9ce08100b25"
  instance_type = "t2.micro"

  security_groups= ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Terraform.." > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  tags = {
    Name:"terraform-example-instance"
  }

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
  ingress {
    from_port = 22 
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 10
}

