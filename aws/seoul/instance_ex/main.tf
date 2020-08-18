provider "aws" {
  region = "ap-northeast-2"
}

/* variable for server_port */

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}


resource "aws_instance" "example" {
  ami = "ami-05438a9ce08100b25"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
 

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Terraform.." > index.html
              nohup busybox httpd -f -p 80 &
              EOF

/*
user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update 
              sudo apt-get install -y  apache2
              sudo service apache2 start 
              EOF
*/
  tags = {
    Name:"terraform-example"
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
