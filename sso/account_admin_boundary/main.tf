resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = "/"
  description = "Permissions boundary for engineers with account-admin access: broad allow, with guardrails against escalation and against removing the boundary itself"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAllPermissionsByDefault",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : "*"
      },
      {
        "Sid" : "RestrictUserAndGroupPolicyActions",
        "Effect" : "Deny",
        "Action" : [
          "iam:DetachUserPolicy",
          "iam:PutUserPolicy",
          "iam:DeleteUserPermissionsBoundary",
          "iam:PutGroupPolicy",
          "iam:AttachGroupPolicy",
          "iam:DeleteGroupPolicy",
          "iam:DetachGroupPolicy",
          "iam:RemoveUserFromGroup",
          "iam:UpdateUser",
          "iam:CreateUser",
          "iam:DeleteUser"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "RestrictNetworkingActions",
        "Effect" : "Deny",
        "Action" : [
          "ec2:CreateDhcpOptions",
          "ec2:DeleteSubnet",
          "ec2:ReplaceRouteTableAssociation",
          "ec2:DetachClassicLinkVpc",
          "ec2:DeleteClientVpnEndpoint",
          "ec2:DeleteVpcPeeringConnection",
          "ec2:CreateTransitGatewayRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:DisableVgwRoutePropagation",
          "ec2:CreateTransitGateway",
          "ec2:ReplaceRoute",
          "ec2:DeleteRouteTable",
          "ec2:RejectVpcPeeringConnection",
          "ec2:DeleteTransitGatewayVpcAttachment",
          "ec2:DeleteVpnGateway",
          "ec2:ReplaceNetworkAclEntry",
          "ec2:CreateRoute",
          "ec2:CreateInternetGateway",
          "ec2:ModifyVpcPeeringConnectionOptions",
          "ec2:CreateVpnGateway",
          "ec2:DeleteInternetGateway",
          "ec2:RejectTransitGatewayVpcAttachment",
          "ec2:DeleteVpnConnection",
          "ec2:CreateVpcPeeringConnection",
          "ec2:EnableVpcClassicLink",
          "ec2:DisassociateTransitGatewayRouteTable",
          "ec2:DisableTransitGatewayRouteTablePropagation",
          "ec2:CreateRouteTable",
          "ec2:DetachInternetGateway",
          "ec2:CreateCustomerGateway",
          "ec2:DisassociateRouteTable",
          "ec2:ReplaceNetworkAclAssociation",
          "ec2:DeleteTransitGatewayRouteTable",
          "ec2:DetachVpnGateway",
          "ec2:CreateTransitGatewayRoute",
          "ec2:DeleteTransitGatewayRoute",
          "ec2:CreateTransitGatewayVpcAttachment",
          "ec2:CreateDefaultVpc",
          "ec2:DeleteDhcpOptions",
          "ec2:DeleteNatGateway",
          "ec2:DeleteVpc",
          "ec2:CreateEgressOnlyInternetGateway",
          "ec2:DeleteTransitGateway",
          "ec2:CreateSubnet",
          "ec2:DeleteNetworkAclEntry",
          "ec2:CreateVpnConnection",
          "ec2:CreateNatGateway",
          "ec2:CreateVpc",
          "ec2:ReplaceTransitGatewayRoute",
          "ec2:CreateDefaultSubnet",
          "ec2:CreateNetworkAcl",
          "ec2:ModifyVpcAttribute",
          "ec2:DeleteNetworkAcl",
          "ec2:ModifyTransitGatewayVpcAttachment",
          "ec2:DeleteEgressOnlyInternetGateway",
          "ec2:DisassociateClientVpnTargetNetwork",
          "ec2:CreateClientVpnRoute",
          "ec2:AttachVpnGateway",
          "ec2:DeleteRoute",
          "ec2:CreateVpnConnectionRoute",
          "ec2:RevokeClientVpnIngress",
          "ec2:DisassociateSubnetCidrBlock",
          "ec2:CreateClientVpnEndpoint",
          "ec2:DeleteVpnConnectionRoute",
          "ec2:AuthorizeClientVpnIngress",
          "ec2:ImportClientVpnClientCertificateRevocationList",
          "ec2:DeleteCustomerGateway",
          "ec2:DeleteClientVpnRoute",
          "ec2:DisableVpcClassicLinkDnsSupport",
          "ec2:DisableVpcClassicLink",
          "ec2:ModifyVpcTenancy",
          "ec2:EnableVpcClassicLinkDnsSupport",
          "ec2:CreateNetworkAclEntry",
          "ec2:AllocateAddress"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "sso:Associate*",
          "sso:Attach*",
          "sso:Delete*",
          "sso-directory:Complete*",
          "sso-directory:Create*",
          "sso-directory:Delete*",
          "sso-directory:Enable*",
          "sso-directory:Disable*",
          "cloudfront:Create*",
          "cloudfront:Delete*",
          "cloudfront:Publish*",
          "cloudtrail:Create*",
          "cloudtrail:Cancel*",
          "cloudtrail:Put*",
          "cloudtrail:Start*",
          "cloudtrail:Update*",
          "config:Delete*",
          "config:Put*",
          "config:Start*",
          "config:Stop*",
          "directconnect:Create*",
          "directconnect:Accept*",
          "fms:Associate*",
          "fms:Delete*",
          "fms:Put*",
          "network-firewall:Create*",
          "network-firewall:Delete*",
          "inspector:Create*",
          "inspector:Stop*",
          "inspector:Start*",
          "inspector2:Enable*",
          "inspector2:Disable*",
          "networkmanager:Create*",
          "nimble:Accept*",
          "nimble:Create*",
          "route53domains:Accept*",
          "route53domains:Update*",
          "route53domains:Transfer*",
          "route53domains:Register*",
          "securityhub:Accept*",
          "securityhub:Create*",
          "securityhub:Delete*",
          "securityhub:Update*",
          "securityhub:Enable*",
          "securityhub:Disable*",
          "transfer:Create*",
          "transfer:Delete*",
          "transfer:Update*",
          "waf:Create*",
          "waf:Delete*",
          "waf:Update*",
          "waf-regional:Create*",
          "waf-regional:Delete*",
          "wafv2:Create*",
          "wafv2:Delete*",
          "wafv2:Update*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "DenyPermissionsBoundaryPolicyChanges",
        "Effect" : "Deny",
        "Action" : [
          "iam:CreatePolicyVersion",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:SetDefaultPolicyVersion"
        ],
        "Resource" : [
          "arn:aws:iam::*:policy/${var.policy_name}"
        ]
      },
      {
        "Sid" : "DenyRemovalOfPermissionsBoundary",
        "Effect" : "Deny",
        "Action" : [
          "iam:DeleteUserPermissionsBoundary",
          "iam:DeleteRolePermissionsBoundary",
          "securityhub:Disable*",
          "transfer:Create*",
          "transfer:Delete*",
          "transfer:Update*",
          "waf:Create*",
          "waf:Delete*",
          "waf:Update*",
          "waf-regional:Create*",
          "waf-regional:Delete*",
          "wafv2:Create*",
          "wafv2:Delete*",
          "wafv2:Update*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "DenyRemovalOfIAMPermissionsBoundary",
        "Effect" : "Deny",
        "Action" : [
          "iam:DeleteUserPermissionsBoundary",
          "iam:DeleteRolePermissionsBoundary"
        ],
        "Resource" : [
          "arn:aws:iam::*:user/*",
          "arn:aws:iam::*:role/*"
        ],
        "Condition" : {
          "StringLike" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::*:policy/${var.policy_name}"
          }
        }
      },
      {
        "Sid" : "DenyCreateRoleWithoutBoundary",
        "Effect" : "Deny",
        "Action" : [
          "iam:CreateRole"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/*"
        ],
        "Condition" : {
          "StringNotLike" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::*:policy/${var.policy_name}"
          }
        }
      },
      {
        "Sid" : "DenyInvalidPermissionsBoundary",
        "Effect" : "Deny",
        "Action" : [
          "iam:PutUserPermissionsBoundary",
          "iam:PutRolePermissionsBoundary"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/*"
        ],
        "Condition" : {
          "StringNotLike" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::*:policy/${var.policy_name}"
          }
        }
      }
    ]
  })
}
