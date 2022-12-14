variable "region" {
  description = "AWS Deployment region.."
  default = "us-west-1"
}

variable vpc_cidr {}
variable public_subnets_cidr {}
variable private_subnets_cidr {}
variable availability_zones {}
variable environment {}