#
# NETWORK
#
resource "aws_eip" "this" {
  instance = "${aws_instance.openvpn_instance.id}"
  vpc      = true

  tags = "${var.tags}"
}

#
# DNS
#
resource "aws_route53_record" "pritunl-openvpn" {
  count   = "${var.instance_dns_record_name_1_enabled == true ? 1 : 0}"
  zone_id = "${var.aws_route53_public_zone_id[0]}"
  name    = "${var.instance_dns_record_name_1}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.openvpn_instance.public_ip}"]
}

resource "aws_route53_record" "webhooks" {
  count   = "${var.instance_dns_record_name_2_enabled == true ? 1 : 0}"
  zone_id = "${var.aws_route53_public_zone_id[0]}"
  name    = "${var.instance_dns_record_name_2}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.openvpn_instance.public_ip}"]
}
