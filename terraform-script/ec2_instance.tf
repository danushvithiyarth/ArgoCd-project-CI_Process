resource "aws_instance" "CI-Machine" {
  ami                         = "ami-075449515af5df0d1"
  instance_type               = var.instance_type_CI
  key_name                    = "keyInterminal"
  subnet_id                   = aws_subnet.A-CD-public-subnet-1a.id
  vpc_security_group_ids      = [aws_security_group.CI-instance-securitygroup.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "CI-Machine"
  }
}

resource "aws_instance" "CD-Machine" {
  ami                         = "ami-075449515af5df0d1"
  instance_type               = var.instance_type_CD
  key_name                    = "keyInterminal"
  subnet_id                   = aws_subnet.A-CD-public-subnet-1a.id
  vpc_security_group_ids      = [aws_security_group.CD-instance-securitygroup.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "CD-Machine"
  }
}
