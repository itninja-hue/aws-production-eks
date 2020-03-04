# IAM role for Eks master nodes
resource "aws_iam_role" "eks-master" {
  name = "eks-master-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
                "Action": "sts:AssumeRole"
        }
    ] 
}
POLICY
}

resource "aws_iam_policy" "describe_account_attributes" {
    name = "Describe_Account_Attributes_Policy"
    description = "DescribeAccountAttributes"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeAccountAttributes"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "Cluster-Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = "${aws_iam_role.eks-master.name}"
}

resource "aws_iam_role_policy_attachment" "Describe-Account-Policy" {
    policy_arn = "${aws_iam_policy.describe_account_attributes.arn}"
    role       = "${aws_iam_role.eks-master.name}"
}
 resource "aws_iam_role_policy_attachment" "Service-Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = "${aws_iam_role.eks-master.name}"
}

# IAM role for Eks worker nodes
resource "aws_iam_role" "eks-workers" {
  name = "eks-worker-roles"
  assume_role_policy = <<POLICY
{
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ] 
}
POLICY
}

resource "aws_iam_role_policy_attachment" "workers-Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-workers.name}"
}

resource "aws_iam_role_policy_attachment" "cni-Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-workers.name}"
}

resource "aws_iam_role_policy_attachment" "ecr-Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = "${aws_iam_role.eks-workers.name}"
}