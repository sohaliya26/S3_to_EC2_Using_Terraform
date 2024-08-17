# Create a key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "day17_key"
  public_key = file("${path.module}/day17_key.pub") #update with your public key name
}

# Create a security group for the EC2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance with the IAM role
resource "aws_instance" "my_ec2_instance" {
  ami                    = var.ami_val # Update with your AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.my_key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "EC2WithS3Access"
  }
}

# Output the EC2 instance's public IP address
output "ec2_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}
