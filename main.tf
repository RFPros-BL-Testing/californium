terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "laird-devops-dev"
  region  = "us-east-1"
}

resource "aws_instance" "californium_server" {
  ami           = "ami-09bee01cc997a78a6"
  instance_type = "t2.medium"
  key_name = "aws_key" 
  vpc_security_group_ids = [aws_security_group.cali-sg.id]
  #subnet_id = aws_subnet.cali-subnet.id
  tags = {
    Name = "cali-ec2"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }  
}

resource "aws_security_group" "cali-sg" {
  vpc_id = aws_default_vpc.default.id  
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 5684
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "udp"
     security_groups  = []
     self             = false
     to_port          = 5684
  }
  ]
  tags = {
    Name = "cali-sg"
  }
}

