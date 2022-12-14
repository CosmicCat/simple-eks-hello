resource "aws_security_group" "public_cluster_instances" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from the outside world"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow all from each other"
    # self-reference - trust other members of this group
    self             = true
    from_port        = 0
    to_port          = 49151
    protocol         = "tcp"
  }

  ingress {
    description      = "Control Plane"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Cluster Instances"
  }
}

resource "aws_instance" "public_instances" {
  count         = var.public_instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet_id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.public_cluster_instances.id]

  tags = {
    Name        = "kube-instance"
  }
}