resource "aws_security_group" "all_vpc" {
  name        = "allow vpc"
  description = "fixme"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow internal traffic on pg port"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr_blocks
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

resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  db_name              = "pg"
  engine               = "postgres"
  engine_version       = "14.5"
  instance_class       = "db.t3.micro"
  username             = var.root_username
  password             = var.root_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_group.name
  vpc_security_group_ids = [aws_security_group.all_vpc.id]
}

resource "aws_db_subnet_group" "rds_group" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}