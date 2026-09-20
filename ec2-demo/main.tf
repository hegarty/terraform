resource "aws_iam_role" "this" {
  name = "${var.ec2_name}-role"
  path = "/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.ec2_name}-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  ])

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "this" {
  name   = "${var.ec2_name}-sec-grp"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux_2.id
  subnet_id                   = var.subnet_id
  instance_type               = "t3.micro"
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name

  tags = {
    Name = var.ec2_name
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1.12 -y
    echo "${var.nginx_message}" | sudo tee /usr/share/nginx/html/index.html
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF
}
