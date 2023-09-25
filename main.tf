resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-ec2-key"  # Specify a new key name here
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0f8e81a3da6e2510a" # Ubuntu instance AMI
  instance_type          = "t2.micro"
  availability_zone      = "us-west-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags = {
    name = "testec2"
  }
}

