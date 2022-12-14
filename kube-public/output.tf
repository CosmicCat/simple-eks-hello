output "public_dns_addrs" {
  value = aws_instance.public_instances.*.public_dns
}
