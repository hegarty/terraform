resource "aws_eip" "this" {
  for_each = var.subnet_ids
  tags = {
    Name = "${var.prefix}_${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each      = var.subnet_ids
  allocation_id = aws_eip.this[each.key].allocation_id
  subnet_id     = each.value

  tags = {
    Name   = "${var.prefix}_${each.key}"
    AZ     = each.key
    Subnet = each.value
  }

  depends_on = [aws_eip.this]
}
