resource "aws_security_group" "eks-worker" {
  name = "eks-worker-nodes"
  description = "Worker nodes security group"
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
    Nodes = "worker"      
  }
}
