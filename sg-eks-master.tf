provider "aws" {
  region = "${var.region}"
  version = "~> 2.47"
}
resource "aws_security_group" "eks-master" {
  name = "eks-master-nodes"
  description = "Master nodes security group"
  vpc_id = "${var.vpc_id}"

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Terraform = "true"
    Environment = "production"
    Nodes = "master"      
  }
}