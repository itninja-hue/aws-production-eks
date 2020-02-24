variable "region" {
  type = string
  default = "eu-west-1"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "eks_cluster-name" {
  type = string
  default = "production-eks"
}

variable "keypair-name" {
  type = string
  description = "ssh Keypair name"
}

variable "private_subnets_ids" {
  type = list(string)
  description = "Private subntes ids list"
}

variable "public_subnets_ids" {
  type = list(string)
  description = "Public subnets ids list"
}

variable "bastion_ingress_cidr_block" {
  type = list(string)
  description = "cidr block list to allow connections in to bastion host"
}

variable "worker_nodes_disk_size" {
  type = string
  description = "worker nodes disk size"
  default = "200"
}

variable "worker_nodes_instance_types" {
  type = list(string)
  description = "worker nodes instance types"
  default = ["t3a.large"]
}

variable "worker_nodes_scaling_desired_size" {
  type = string
  description = "worker nodes scaling desired size"
  default = "3"
}

variable "worker_nodes_scaling_max_size" {
  type = string
  description = "worker nodes scaling max size"
  default = "5"
}

variable "worker_nodes_scaling_min_size" {
  type = string
  description = "worker nodes scaling min size"
  default = "3"
}


