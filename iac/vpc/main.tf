provider "aws" {
  region = var.region
}

// aws-vpc-dev
terraform {
  backend "remote" {
    organization = "mberthos"

    workspaces {
      prefix = "aws-vpc-" 
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name     = var.name
  cidr     = var.cidr

  //create_vpc = false

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  enable_dhcp_options              = var.enable_dhcp_options
  dhcp_options_domain_name         = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers
  dhcp_options_ntp_servers         = var.dhcp_options_ntp_servers
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support

  tags = {
    Terraform = "true"
    Environment = var.env
    BillingCode = "ITOPSVPC"
  }
}
