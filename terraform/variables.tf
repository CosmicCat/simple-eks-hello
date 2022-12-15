variable "region" {
  description = "AWS Deployment region.."
  default = "us-west-1"
}

variable "environment" {
  default = "kube"
}

variable "availability_zones" {
  description = "Change these if you are running somewhere other than us-west-1"
  default = ["us-west-1a", "us-west-1c"]
}