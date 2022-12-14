module "networking" {
  source = "./networking"
  region               = "${var.region}"
  environment          = "${var.environment}"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets_cidr = ["10.0.200.0/24"]
  availability_zones   = ["us-west-1a", "us-west-1c"]
}

module "eks" {
  source = "./eks"
  subnet_ids = module.networking.public_subnet_ids
}

/*
module "kube-public" {
  source = "./kube-public"
  vpc_id = module.networking.vpc_id
  public_subnet_id = module.networking.public_subnet_id
}

output "public_dns_addrs" {
  value = module.kube-public.public_dns_addrs
}
*/
