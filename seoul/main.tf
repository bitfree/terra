provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami = "ami-05438a9ce08100b25"
  instance_type = "t2.micro"
  tags = {
    Name:"terraform-example"
  }
}


