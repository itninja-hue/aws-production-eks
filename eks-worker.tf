resource "aws_eks_node_group" "eks-workers" {
    cluster_name = "${aws_eks_cluster.eks.name}"
    node_group_name = "production_worker_nodes"
    node_role_arn = "${aws_iam_role.eks-workers.arn}"
    subnet_ids = "${var.private_subnets_ids}"
    disk_size = "${var.worker_nodes_disk_size}"
    instance_types = "${var.worker_nodes_instance_types}"
    version = "1.14"
    remote_access {
        ec2_ssh_key = "${var.keypair-name}"
        source_security_group_ids = ["${aws_security_group.eks-bastion.id}"]
    }

    scaling_config{
        desired_size = "${var.worker_nodes_scaling_desired_size}"
        max_size = "${var.worker_nodes_scaling_max_size}"
        min_size = "${var.worker_nodes_scaling_min_size}"
    }
    depends_on= [
        "aws_eks_cluster.eks",
        "aws_iam_role_policy_attachment.workers-Policy",
        "aws_iam_role_policy_attachment.cni-Policy",
        "aws_iam_role_policy_attachment.ecr-Policy"
    ]
    tags = {
        Name = "production-worker-nodes"
        Terraform = "true"      
        Environment = "production"
    }
}
