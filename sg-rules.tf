# Bastion host security group rules
resource "aws_security_group_rule" "ingress-master-bastion" {
  description = "Allow Master nodes to recive https connection from Bastion"
  source_security_group_id = "${aws_security_group.eks-bastion.id}"
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.eks-master.id}"
  to_port = 443
  type ="ingress"
}