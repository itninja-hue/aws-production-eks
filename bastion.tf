locals {
  bastion-user-data = <<USERDATA
    #!/usr/bin/env bash
    init_func(){
        mkdir -p ~/.kube; echo "${local.kubeconfig}" > ~/.kube/config
        curl -o ~/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
        curl -o ~/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
        chmod +x ~/aws-iam-authenticator
        chmod +x ~/kubectl
    }
    export -f init_func
    /bin/su ec2-user -c 'init_func'
    mv /home/ec2-user/kubectl /usr/local/bin
    mv /home/ec2-user/aws-iam-authenticator /usr/local/bin
    USERDATA
}

resource "aws_launch_configuration" "bastion-host" {
    name_prefix = "production-bastion"
    image_id = "ami-028188d9b49b32a80"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.eks-bastion.id}"]
    associate_public_ip_address = "true"
    key_name = "${var.keypair-name}"
    user_data = "${base64encode(local.bastion-user-data)}"
    lifecycle {
        create_before_destroy = true
    }
    root_block_device {
            volume_type = "gp2"
            volume_size = "50"
    }
}

resource "aws_autoscaling_group" "bastion-autoscaling-group" {
    launch_configuration = "${aws_launch_configuration.bastion-host.id}"
    desired_capacity = "1"
    max_size = "2"
    min_size = "1"
    vpc_zone_identifier = "${var.public_subnets_ids}"
    depends_on = [
        "aws_eks_cluster.eks"
    ]
}