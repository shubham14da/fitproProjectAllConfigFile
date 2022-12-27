provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "prod-subnet"
}
}

resource "aws_route_table_association" "a" {
  subnet_id         = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}


resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

ingress {
    description      = "All_traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 }

  tags = {
    Name = "allow_all"
 }
}


resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ansible.id
  allocation_id = "eipalloc-02e7a0ec93180e54c"
}
/*
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = ""
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.k8s-master.id
  allocation_id = ""
}

*/

resource "aws_instance" "jenkins" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.medium"
  #availability_zone ="us-east-2b"
  associate_public_ip_address= true
  key_name = "winkey" 
  subnet_id = aws_subnet.subnet-1.id 
  private_ip = "10.0.1.51"
  root_block_device   {
      volume_type = "gp2"
      volume_size = "30"
      tags = {
        Name= "jenkins-volume"
      }
      }

  #user_data         = file("jenkins.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "jenkins"
  }
}



/*
resource "aws_instance" "stagging" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.xlarge"
  associate_public_ip_address= true
  #availability_zone ="us-east-2b"
  key_name = "winkey" 
  subnet_id = aws_subnet.subnet-1.id 
  private_ip = "10.0.1.55"
  root_block_device   {
      volume_type = "gp2"
      volume_size = "30"
      tags = {
        Name= "stagging-volume"
      }
}

 # user_data         = file("staging.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "stagging"
  }
} */

resource "aws_instance" "ansible" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.large"
  associate_public_ip_address= true
  #availability_zone ="us-east-2b"
  key_name = "winkey" 
  private_ip = "10.0.1.50"
  subnet_id = aws_subnet.subnet-1.id 
  root_block_device   {
      volume_type = "gp2"
      volume_size = "30"
      tags = {
        Name= "ansible-volume"
      }
}
 user_data         = file("ansible.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "ansible"
  }
}

resource "aws_instance" "k8s-master" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.medium"
  associate_public_ip_address= true
  private_ip = "10.0.1.52"
  #availability_zone ="us-east-2b"
  key_name = "winkey" 
  subnet_id = aws_subnet.subnet-1.id 
  root_block_device   {
      volume_type = "gp2"
      volume_size = "30"
      tags = {
        Name= "k8s-master-volume"
      }
}
# user_data         = file("docker.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "workernode1" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.micro"
  associate_public_ip_address= true
  #availability_zone ="us-east-2b"
  private_ip = "10.0.1.53"
  key_name = "winkey" 
  subnet_id = aws_subnet.subnet-1.id 
  root_block_device   {
      volume_type = "gp2"
      volume_size = "10"
      tags = {
        Name= "workernode1-volume"
      }
}
# user_data         = file("docker.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "workernode1"
  }
}

resource "aws_instance" "workernode2" {
  ami           = "ami-0568773882d492fc8"
  instance_type = "t2.micro"
  associate_public_ip_address= true
  #availability_zone ="us-east-2b"
  private_ip = "10.0.1.54"
  key_name = "winkey" 
  subnet_id = aws_subnet.subnet-1.id 
  root_block_device   {
      volume_type = "gp2"
      volume_size = "10"
      tags = {
        Name= "workernode2-volume"
      }
}
# user_data         = file("docker.sh")
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "workernode2"
  }
}


output "jenkin_ip" {
    value = aws_instance.jenkins.public_ip
#    value = aws_instance.web-server-interface.id
}

/*output "stagging_ip" {
    value = aws_instance.stagging.public_ip
}*/

output "ansible_ip" {
    value = aws_instance.ansible.public_ip
}
output "k8s-master_ip" {
    value = aws_instance.k8s-master.public_ip
}
output "workernode1_ip" {
    value = aws_instance.workernode1.public_ip
}
output "workernode2_ip" {
    value = aws_instance.workernode2.public_ip
}
