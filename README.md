# aws-production-eks
Terraform script for production grade eks provisioning.


## Getting Started

Terraform script that provision a private eks cluster with a bastion host.

### Prerequisites

Virtual private cloud with private and public subnets.


### Usage

#### Default

```terraform

module "production-eks" {
    source = "github.com/itninja-hue/aws-production-eks"
    vpc_id = "vpcXXXX"
    keypair-name = "ssh_production_keypair"
    private_subnet_ids = ["private_subnet_id1","private_subnet_id2"]
    public_subnet_ids = ["public_subnet_id1","public_subnet_id2"]
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
    private_subnet_ids = ["private_subnet_id1","private_subnet_id2"]
    public_subnet_ids = ["public_subnet_id1","public_subnet_id2"]
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
terraform apply
```

## Authors

* **itninja-hue** - *Initial work* - [itninja-hue](https://github.com/itninja-hue)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
