# EKS terraform module

Minimal configuration to build an EKS and run a small workload.

## Attribution

Most of the code came from the examples in the terraform documentation for the `aws_eks_cluster` and `aws_eks_node_group` resources.

## Limitations

For simplicity, control plane nodes are on public subnets, but should otherwise be inaccessible.