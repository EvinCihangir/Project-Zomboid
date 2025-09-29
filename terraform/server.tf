resource "tls_private_key" "gamer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "gaming" {
  key_name   = "deployer-key"
  public_key = tls_private_key.gamer.public_key_openssh
}


module "pz" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "pz-server"

  root_block_device = {
    type       = "gp3"
    throughput = 200
    size       = 128
  }
  ami                         = data.aws_ami.ubuntu_jammy.id
  user_data_base64            = base64encode(data.template_file.pz.rendered)
  user_data_replace_on_change = true
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.pz.id]
  create_eip                  = true
  key_name                    = aws_key_pair.gaming.key_name
  monitoring                  = false
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
