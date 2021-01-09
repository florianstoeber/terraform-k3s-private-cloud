data "aws_ami" "amazon-linux-2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.this.id
}

locals {
  name            = var.cluster_name
  master_count    = 1
  node_count      = 3
  master_ami      = var.master_ami != null ? var.master_ami : data.aws_ami.amazon-linux-2.id
  node_ami        = var.node_ami != null ? var.node_ami : data.aws_ami.amazon-linux-2.id
  master_vol      = 50
  node_vol        = 50
  public_subnets  = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnet_ids.available.ids
  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnet_ids.available.ids
}
