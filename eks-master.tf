resource "aws_eks_cluster" "eks" {
  name = "${var.eks_cluster-name}"
  version = "1.14"
  role_arn = "${aws_iam_role.eks-master.arn}"
  vpc_config {
      security_group_ids = ["${aws_security_group.eks-master.id}"]
      subnet_ids = "${var.private_subnets_ids}"
      endpoint_private_access = true
      endpoint_public_access = false
  }
  depends_on = [
      "aws_iam_role_policy_attachment.Cluster-Policy",
      "aws_iam_role_policy_attachment.Service-Policy",
      "aws_iam_role_policy_attachment.ecr-Policy"
  ]
}