terraform {
  backend "remote" {
    organization = "mberthos"

    workspaces {
      prefix = "aws-eks-"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

data "aws_availability_zones" "available" {
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  #Depends_on criado para forçar a a criação de Logs no AWS EKS
  depends_on = [aws_cloudwatch_log_group.eks-cluster-logs]
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"
  //cluster_name    = local.cluster_name
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.private_subnets      // module.vpc.private_subnets
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  tags = {
    Environment = var.environment
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id =  var.vpc_id    // module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    dmz = {
      subnets         = var.public_subnets
      desired_capacity = var.public_desired_capacity
      min_capacity     = var.public_min_capacity
      max_capacity     = var.public_max_capacity

      instance_types = var.dmz_instance_types //  ["t3.small"]
      capacity_type  =  var.capacity_type  //["SPOT","ON_DEMAND"]
      k8s_labels = {
        Environment = var.environment
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Zone        = "dmz"

      }
      additional_tags = {
        Militarized  = false
        BillingCode  = "OPTI.K8S"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" =	true
      }
      /*taints = [
        {
          key    = "zone"
          value  = "dmz"
          effect = "NO_SCHEDULE"
        }
      ]*/
    },

    sec = {
      desired_capacity = var.private_desired_capacity
      min_capacity     = var.private_min_capacity
      max_capacity     = var.private_max_capacity

      instance_types = var.sec_instance_types  // ["t3.large"]
      capacity_type  = var.capacity_type   // "SPOT"   //"ON_DEMAND"
      k8s_labels = {
        Environment = var.environment
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Zone        = "sec"
      }
      additional_tags = {
        Militarized  = true
        BillingCode  = "OPTI.K8S"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" =	true

      }
      /*taints = [
        {
          key    = "zone"
          value  = "sec"
          effect = "NO_SCHEDULE"
        }
      ]*/
    },

    #dmz_new_test = {
    #  subnets         = var.public_subnets
    #  desired_capacity = var.public_desired_capacity
    #  min_capacity     = var.public_min_capacity
    #  max_capacity     = var.public_max_capacity
    #
    #  instance_types = var.dmz_instance_types //  ["t3.small"] /
    #  capacity_type  =  var.capacity_type  //["SPOT","ON_DEMAND"]
    #  k8s_labels = {
    #    Environment = var.environment
    #    GithubRepo  = "terraform-aws-eks"
    #    GithubOrg   = "terraform-aws-modules"
    #    Zone        = "dmz"
    #  }
    #  additional_tags = {
    #    Militarized  = false
    #    BillingCode  = "OPTI.K8S"
    #  }
    #  /*taints = [
    #    {
    #      key    = "zone"
    #      value  = "dmz"
    #      effect = "NO_SCHEDULE"
    #    }
    #  ]*/
    #}

  }

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts

  # Create security group rules to allow communication between pods on workers and pods in managed node groups.
  # Set this to true if you have AWS-Managed node groups and Self-Managed worker groups.
  # See https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1089

  # worker_create_cluster_primary_security_group_rules = true

  # worker_groups_launch_template = [
  #   {
  #     name                 = "worker-group-1"
  #     instance_type        = "t3.small"
  #     asg_desired_capacity = 2
  #     public_ip            = true
  #   }
  # ]
}
#Resouce utilizado para cooperar com o Control Plane Logging do AWS EKS
resource "aws_cloudwatch_log_group" "eks-cluster-logs" {
    name = format("%s-log-group", var.cluster_name)

    tags = {
      "Description" = "Log group destinado a monitoramento do AWS EKS"
      "Responsable" = "X-Ops Team"
    }
}
resource "aws_cloudwatch_log_stream" "eks-log" {
  name           = format("%s-log", var.cluster_name)
  log_group_name = aws_cloudwatch_log_group.eks-cluster-logs.name
}
