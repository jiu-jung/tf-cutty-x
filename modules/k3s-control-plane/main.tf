resource "aws_instance" "control_plane" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false

  security_groups      = [var.security_group_id]
  iam_instance_profile = var.iam_instance_profile
  user_data            = filebase64("${path.root}/userdata/k3s-control.sh")

  tags = { Name = "k3s-control-plane" }
}
