AWS Networking Terraform Configuration

This Terraform configuration provisions the core networking resources for an AWS VPC, including subnets, internet gateways, NAT gateways, and route tables. It follows best practices for high availability and network isolation.

## Architecture

The configuration creates the following resources:

1. **VPC**: A Virtual Private Cloud to host your AWS resources.
2. **Subnets**: Public and private subnets distributed across multiple Availability Zones for high availability.
   - Public Subnets: For resources that need internet access (e.g. load balancers)
   - Private Subnets: For resources that don't need internet access (e.g. most everythng else)
3. **Internet Gateway**: Allows resources in the public subnets to access the internet.
4. **NAT Gateways**: Allows resources in the private subnets to access the internet while preventing incoming connections.
5. **Route Tables and Routes**: Configure routing between subnets and gateways.

## Configuration

### VPC

The VPC configuration is defined in `hegarty/terraform/networking/vpc`. You can customize the following variables:

- `vpc_name`: Prefix for resource names in the VPC
- `vpc_cidr`: IP address range for the VPC in CIDR notation
- `enable_dns_support`: Enable DNS resolution within the VPC (default: true)
- `enable_dns_hostnames`: Enable DNS hostnames for resources in the VPC (default: true)
- `assign_ipv6`: Assign an IPv6 CIDR block to the VPC (default: false)
- `environment`: Environment tag for resources
- `subnets`: List of subnet configurations (see below)

#### Subnet Configuration

The `subnets` variable is a list of objects with the following keys:

- `availability_zone_id`: Availability Zone ID for the subnet
- `cidr`: CIDR block for the subnet IP range
- `tags`: Tags to apply to the subnet, including:
  - `use`: Purpose of the subnet (e.g. "controller", "ingress-egress", "worker")
  - `type`: Type of subnet ("public" or "private")

### Internet Gateway

The internet gateway configuration is in `hegarty/terraform/networking/internet_gateway`. It creates an internet gateway and associates it with the VPC.

### NAT Gateways

The NAT gateway configuration is in `hegarty/terraform/networking/nat_gateway`. It creates an Elastic IP address and a NAT gateway in each of the specified public subnets.

### Route Tables and Routes

The route table configuration is in `hegarty/terraform/networking/routes`. It creates route tables for each subnet and associates them. It also creates routes to the internet gateway for public subnets and to the NAT gateways for private subnets.

## Outputs

After applying the configuration, you can access the following outputs:

- `vpc_id`: ID of the created VPC
- `public_subnets`: Map of public subnet IDs by Availability Zone
- `controller_subnets`: Map of controller subnet IDs by Availability Zone
- `worker_subnets`: Map of worker subnet IDs by Availability Zone
- `subnet_cidr`: Map of subnet CIDR blocks by subnet name and Availability Zone

Use these outputs to reference the created resources in other parts of your infrastructure configuration.
