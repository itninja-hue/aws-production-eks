# aws-production-eks
Terraform script for production grade eks provisioning.


## Getting Started

Terraform script that provision a private eks cluster with a bastion host.

### Prerequisites

VPC (virtual private cloud) with private and public subnets.

You can use this straight away implmentation of terraform-aws-modules/vpc/aws module.

```terraform
provider "aws" {
  region = "INSERT REGION" //example eu-west-1
  version = "~> 2.47"
}
resource "aws_eip" "nat" {
  count = 3
  vpc = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "INSERT VPC NAME" //example production-vpc
  cidr = "VPC CIDR BLOCK" //example 10.120.0.0/16

  azs = "AVAILABILTY ZONES LIST" //example ["eu-west-1b", "eu-west-1a", "eu-west-1c"]
  private_subnets = "PRIVATE SUBNETS LIST" //example ["10.120.10.0/24","10.120.11.0/24","10.120.12.0/24"]
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" : "1"
  }
  public_subnets = "PUBLIC SUBNETS LIST" // example ["10.120.0.0/24","10.120.1.0/24","10.120.2.0/24"]
  public_subnet_tags = {
    "kubernetes.io/role/elb" : "1"
  }
  enable_nat_gateway = true
  single_nat_gateway  = false
  reuse_nat_ips       = true  
  external_nat_ip_ids = aws_eip.nat.*.id
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_s3_endpoint = true
tags = {
    "Terraform" : "true"
    "Environment" : "production"
    "kubernetes.io/cluster/production-eks" : "shared"
  }
}
```
**All tags starting with kubernetes.io are mandatory for resource binding thus shouldn't be deleted**

### Usage

#### Default

```terraform

module "production-eks" {
    source = "github.com/itninja-hue/aws-production-eks"
    vpc_id = "vpcXXXX"
    keypair-name = "ssh_production_keypair"
    private_subnets_ids = ["private_subnet_id1","private_subnet_id2"]
    public_subnets_ids = ["public_subnet_id1","public_subnet_id2"]
    bastion_ingress_cidr_block = ["cidr_block_1","cidr_block_2"]
}

```
#### All params

```terraform

module "production-eks" {
    source = "github.com/itninja-hue/aws-production-eks"
    region = "region_name"
    vpc_id = "vpcXXXX"
    eks_cluster-name = "production_cluster"
    keypair-name = "ssh_production_keypair"
    private_subnets_ids = ["private_subnet_id1","private_subnet_id2"]
    public_subnets_ids = ["public_subnet_id1","public_subnet_id2"]
    worker_nodes_disk_size = "200"
    worker_nodes_instance_types = ["t3a.large"]
    worker_nodes_scaling_desired_size = "3"
    worker_nodes_scaling_max_size = "5"
    worker_nodes_scaling_min_size = "3"
    bastion_ingress_cidr_block = ["cidr_block_1","cidr_block_2"]
}

```


## Deployment

```bash
terraform init
terraform apply
```
## Accessing the cluster

ssh to the bastion host.


Set your Access Keys as environment variables
```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCEXAMPLEKEY
#interact with cluster
kubectl get nodes
```

## Post Deployment

This script will deploy Eks with EBS block storage as default storage class.
The following terraform script will deploy EFS with multi availabilty zone mount targets (make sure to match the AZ with ones you deployed your worker nodes in).
```terraform
resource "aws_security_group" "efs-mount-targets" {
  name = "efs-mount-targets"
  description = "efs mount targets security group"
  vpc_id = "VPC ID" //example vpcXXXX
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "production-efs" {
  creation_token = "eks-efs"

  tags = {
    Name = "production-efs"
    Terraform = "true"
    Environment = "production"
  }
}
resource "aws_efs_mount_target" "eu-west-1c" {
  file_system_id = "${aws_efs_file_system.production-efs.id}"
  subnet_id      = "AZ 1 PRIVATE CIDR" // example 10.120.10.0/24
  security_groups = ["${aws_security_group.efs-mount-targets.id}"]
}
resource "aws_efs_mount_target" "eu-west-1a" {
  file_system_id = "${aws_efs_file_system.production-efs.id}"
  subnet_id      = "AZ 2 PRIVATE CIDR" //example 10.120.11.0/24
  security_groups = ["${aws_security_group.efs-mount-targets.id}"]
}
resource "aws_efs_mount_target" "eu-west-1b" {
  file_system_id = "${aws_efs_file_system.production-efs.id}"
  subnet_id      = "AZ 3 PRIVATE CIDR" //example 10.120.12.0/24
  security_groups = ["${aws_security_group.efs-mount-targets.id}"]
}

resource "aws_security_group_rule" "ingress-mount_targets-worker_nodes" {
  description = "Allow mount targets to recive connection from worker nodes"
  source_security_group_id = "WORKER NODES SECURITY GROUP ID" //example sg-XXXXXXXXXXX
  from_port = 2049
  protocol = "tcp"
  security_group_id = "${aws_security_group.efs-mount-targets.id}"
  to_port = 2049
  type ="ingress"
}
```
## Authors

* **itninja-hue** - *Initial work* - [itninja-hue](https://github.com/itninja-hue)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
