# EKS VPC and Subnet Configuration

This Terraform configuration provisions an AWS VPC and subnets for an Amazon Elastic Kubernetes Service (EKS) cluster deployment. The configuration follows best practices for EKS, including distributing subnets across multiple Availability Zones for high availability and optimizing IP space allocation based on subnet requirements.

## Prerequisites

- Terragrunt installed and configured
- AWS credentials configured with appropriate permissions

## Usage

1. Navigate to the `eks/us-east-1/networking/vpc` directory.
2. Run `terragrunt init` to initialize the working directory.
3. Run `terragrunt plan` to preview the changes.
4. Run `terragrunt apply` to apply the configuration and create the VPC and subnets.

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `vpc_name` | Name of the VPC (prefix for resource names) | `include.root.locals.account_name` |
| `vpc_cidr` | CIDR block for the VPC | `"10.0.24.0/21"` |
| `enable_dns_support` | Enable DNS support in the VPC | `true` |
| `enable_dns_hostnames` | Enable DNS hostnames in the VPC | `true` |
| `assign_ipv6` | Assign IPv6 CIDR block | `false` |
| `subnets` | List of subnet configurations | See `terragrunt.hcl` |

The `subnets` variable is a list of maps, where each map represents a subnet configuration with the following keys:

- `use`: Purpose of the subnet (e.g., "controller", "ingress-egress", "worker")
- `type`: Type of the subnet ("private" or "public")
- `availability_zone_id`: Availability Zone ID for the subnet
- `cidr`: CIDR block for the subnet

## Outputs

| Output | Description |
|--------|-------------|
| `vpc` | Details of the created VPC |

The `vpc` output provides information about the created VPC, including the VPC ID, CIDR block, DNS support status, and other attributes.

## Subnet Breakdown

The `subnets` configuration in `terragrunt.hcl` defines the following subnets:

### Controller Subnets

- 2 private subnets with CIDR blocks of `/28` (16 IP addresses each, 32 IP addresses total)
- Allocated in a contiguous manner within the VPC CIDR range
- Distributed across `use1-az1` and `use1-az2` Availability Zones

### Ingress-Egress Subnets

- 3 public subnets with CIDR blocks of `/25` (128 IP addresses each, 384 IP addresses total)
- Allocated immediately after the controller subnets in the VPC CIDR range
- Distributed across `use1-az1`, `use1-az2`, and `use1-az4` Availability Zones

### Worker Subnets

- 3 private subnets with CIDR blocks of `/23` (512 IP addresses each, 1,536 IP addresses total)
- Allocated immediately after the ingress-egress subnets in the VPC CIDR range
- Distributed across `use1-az1`, `use1-az2`, and `use1-az4` Availability Zones

## CIDR Allocation

The CIDR blocks are allocated in the following contiguous manner within the VPC CIDR range:
