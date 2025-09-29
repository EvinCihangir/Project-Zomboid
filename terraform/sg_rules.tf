resource "aws_security_group" "pz" {
  name        = "pz-server-sg"
  description = "Project Zomboid dedicated server"
  vpc_id      = module.vpc.vpc_id
}

# Inbound: open required UDP ports
resource "aws_vpc_security_group_ingress_rule" "pz_udp" {
  for_each = toset([for p in var.pz_udp_ports : tostring(p)])

  security_group_id = aws_security_group.pz.id
  ip_protocol       = "udp"
  from_port         = tonumber(each.key)
  to_port           = tonumber(each.key)


  cidr_ipv4 = length(var.allowed_cidrs) == 1 ? var.allowed_cidrs[0] : null

}

resource "aws_vpc_security_group_ingress_rule" "pz_ssh" {

  security_group_id = aws_security_group.pz.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  cidr_ipv4 = "0.0.0.0/0"

}

# Egress: allow all (adjust if you run a restrictive egress posture)
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.pz.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
