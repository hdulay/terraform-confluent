provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "us-east-1"
}

resource "aws_security_group" "ubuntu_allow_all" {
  name        = "hubert_allow_all"
  description = "Allow All traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "zk" {
  count = 3
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-zk"
    Owner = "hubert"
    type = "zookeeper"
  }
}

resource "aws_instance" "broker" {
  count = 3
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-broker"
    Owner = "hubert"
    type = "kafka_broker"
  }
}

resource "aws_instance" "c3" {
  count = 1
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.large"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-c3"
    Owner = "hubert"
    type = "kafka_c3"
  }
}


resource "aws_instance" "sr" {
  count = 1
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-sr"
    Owner = "hubert"
    type = "kafka_sr"
  }
}

resource "aws_instance" "connect" {
  count = 1
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-connect"
    Owner = "hubert"
    type = "kafka_connect"
  }
}


resource "aws_instance" "ksql" {
  count = 1
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name   = "hubert-se"
  vpc_security_group_ids = ["${aws_security_group.ubuntu_allow_all.name}"]

  tags = {
    Name = "hubert-tf-ksql"
    Owner = "hubert"
    type = "kafka_ksql"
  }
}

output "zookeeper" {
  value = "${aws_instance.zk.*.public_dns}"
}
output "kafka_broker" {
  value = "${aws_instance.broker.*.public_dns}"
}
output "control_center" {
  value = "${aws_instance.c3.*.public_dns}"
}
output "schema_registry" {
  value = "${aws_instance.sr.*.public_dns}"
}
output "kafka_connect" {
  value = "${aws_instance.connect.*.public_dns}"
}
output "ksql" {
  value = "${aws_instance.ksql.*.public_dns}"
}
