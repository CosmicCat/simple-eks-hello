# Simple EKS Cluster with RDS

## Purpose

A very minimal implementation of EKS with a single node cluster. Hosts a single hello world app via port 80. 

## Usage

See the top level readme for a list of needed permissions for the user running this terraform.

```
cd ${this_directory}
terraform init
terraform apply
```

## Issues

Cluster and RDS are on a public subnet due to ease of implementation. I've not needed to access individual nodes, nor needed direct access to the RDS while devving on this. Fun only - please no real-world applications.

You may need to pass in custom region or availibility zone names.