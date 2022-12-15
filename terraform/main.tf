module "networking" {
  source = "./networking"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets_cidr = ["10.0.200.0/24"]
  availability_zones   = var.availability_zones
}

module "eks" {
  source = "./eks"
  subnet_ids = module.networking.public_subnet_ids
}

module "rds" {
  source = "./rds"
  vpc_id = module.networking.vpc_id
  root_username = "fred"
  root_password = "supersecure"
  subnet_ids = module.networking.public_subnet_ids
  allow_cidr_blocks = ["10.0.0.0/16"]
}

