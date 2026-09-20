resource "aws_route53_zone_association" "this" {
  for_each = toset(var.vpc_ids)
  vpc_id   = each.value
  zone_id  = var.zone_id
}
