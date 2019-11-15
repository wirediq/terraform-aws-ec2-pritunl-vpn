#
# Security Resources
#

#
# Security Groups
#
module "sg_private" {
  source = "git::https://github.com/binbashar/terraform-aws-sec-groups.git?ref=v0.0.2"

  security_group_name = "${var.sg_private_name}"
  tcp_ports           = "${var.sg_private_tpc_ports}"
  udp_ports           = "${var.sg_private_udp_ports}"
  cidrs               = ["${var.sg_private_cidrs}"]
  vpc_id              = "${var.aws_vpc_id}"

  tags = "${var.tags}"
}

module "sg_public" {
  source = "git::git@github.com:binbashar/terraform-aws-sec-groups.git?ref=v0.0.2"

  security_group_name = "${var.sg_public_name}"
  tcp_ports           = "${var.sg_public_tpc_ports}"
  udp_ports           = "${var.sg_public_udp_ports}"
  cidrs               = ["${var.sg_public_cidrs}"]
  vpc_id              = "${var.aws_vpc_id}"

  tags = "${var.tags}"
}

#
# Security Groups Temporary access
#
#======================================================================================================#
# NO MODULAR since we use count as conditional enabled flag
# https://stackoverflow.com/questions/50186380/variance-in-attributes-based-on-count-index-in-terraform
# https://github.com/hashicorp/terraform/issues/18923
# https://github.com/hashicorp/terraform/issues/953
#======================================================================================================#
#
resource "aws_security_group" "sg_public_temporary" {
  count       = "${var.sg_public_temporary_enabled}"
  name        = "${var.sg_public_temporary_name}"
  description = "Allow temporary access for ${var.sg_public_temporary_name} to ${element(var.sg_public_temporary_tpc_ports, count.index)}"
  vpc_id      = "${var.aws_vpc_id}"

  tags = "${var.tags}"
}

resource "aws_security_group_rule" "ingress" {
  count       = "${length(var.sg_public_temporary_tpc_ports)}"
  type        = "ingress"
  from_port   = "${element(var.sg_public_temporary_tpc_ports, count.index)}"
  to_port     = "${element(var.sg_public_temporary_tpc_ports, count.index)}"
  protocol    = "tcp"
  cidr_blocks = ["${var.sg_public_temporary_cidrs}"]
  description = "temporary public access"

  security_group_id = "${aws_security_group.sg_public_temporary.id}"
}
