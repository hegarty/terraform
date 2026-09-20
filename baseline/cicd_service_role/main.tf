resource "aws_iam_role" "this" {
  name = "${var.policy_name}-role"
  path = "/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${var.principal_account_id}"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : "${var.principal_org_id}",
            "aws:PrincipalArn" : [
              "arn:aws:iam::${var.principal_account_id}:role/${var.assuming_role_name}"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = "/"
  description = "CICD service policy used to run terragrunt apply"

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

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
