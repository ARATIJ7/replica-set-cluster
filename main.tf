provider "aws" {
  region = "us-east-1"  # Specify your desired region
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb_sg"
  description = "Allow SSH and MongoDB traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
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

resource "aws_instance" "mongodb" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "demo"  # Replace with your key pair name

  user_data = templatefile("userdata.sh", {
    instance_number = count.index + 1
  })

  tags = {
    Name = "MongoDBInstance${count.index + 1}"
  }

  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  depends_on = [aws_security_group.mongodb_sg]
}

output "instance_ips" {
  value = aws_instance.mongodb.*.public_ip
}
