
resource "aws_iam_role" "ccm" {
  name               = var.role_name
  assume_role_policy = jsonencode(var.assume_role_policy) # accepts map/object from TG
}

resource "aws_iam_policy" "this" {
  count       = var.policy != null ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  policy      = var.policy
}

resource "aws_iam_policy" "ccm" {
  name   = "${var.cluster_name}-ccm-policy"
  policy = data.aws_iam_policy_document.ccm_permissions.json
}

resource "aws_iam_role_policy_attachment" "ccm" {
  role       = aws_iam_role.ccm.name
  policy_arn = aws_iam_policy.ccm.arn
}
