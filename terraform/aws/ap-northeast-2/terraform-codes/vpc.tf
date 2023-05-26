resource "aws_vpc" "shlee-vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "20.0.0.0/16"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "shlee-vpc"
  }

  tags_all = {
    Name = "shlee-vpc"
  }
}
