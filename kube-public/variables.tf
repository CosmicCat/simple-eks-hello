variable "vpc_id" {}
variable "public_subnet_id" {}

variable "public_instance_count" {
  default = "2"
}

# lift these up

variable "instance_type" {
  # smallest that kubeadm is willing to run on
  default = "t3.small"
}

variable "ami" {
  # ubuntu 20.04 - us-west-1 only
  default = "ami-03f6d497fceb40069"
}

variable "key_name" {
  default = "matthew"
}