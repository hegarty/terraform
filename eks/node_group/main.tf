locals {
  # Stay out of us-east-1e
  filtered_subnets = { for az, subnet_id in var.subnet_ids : az => subnet_id if az != "us-east-1e" }
}

resource "aws_launch_template" "this" {
  name_prefix = "${var.name}-lt-"
  update_default_version = true

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size = block_device_mappings.value.ebs.volume_size
        volume_type = block_device_mappings.value.ebs.volume_type
        encrypted   = block_device_mappings.value.ebs.encrypted
      }
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options
    content {
      http_tokens = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name"                                      = "${var.name}-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = values(local.filtered_subnets)

  ami_type        = var.ami_type
  capacity_type   = var.capacity_type #"ON_DEMAND"
  instance_types  = var.instance_types

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tags = {
    "Name" = "${var.name}-node-group"
  }

}
