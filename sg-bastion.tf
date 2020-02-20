resource "aws_security_group" "eks-bastion" {
  name = "eks-bastion"
  description = "Bastion security group"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 0
      to_port = 22
      protocol = "tcp"
      cidr_blocks = "${var.bastion_ingress_cidr_block}"
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Terraform = "true"
    Environment = "production"
    type = "bastion"      
  }
}