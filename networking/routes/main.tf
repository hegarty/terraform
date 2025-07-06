resource "aws_route_table" "this" {
  for_each = var.subnets
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.route-table_prefix}_${each.key}"
    AZ   = each.key
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.subnets
  subnet_id      = each.value
  route_table_id = aws_route_table.this[each.key].id
}

resource "aws_route" "this" {
  for_each               = var.subnets
  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = var.destination_cidr

  gateway_id     = var.gateway_id
  nat_gateway_id = contains(keys(var.nat_ids), each.key) ? var.nat_ids[each.key] : null

  depends_on = [aws_route_table.this]
}
