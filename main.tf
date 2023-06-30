resource "aws_vpc" "estudos" {
  cidr_block = "172.16.0.0/16"
}

#SO ultilizado 
data "aws_ami" "ubuntu"{
  most_recent = true
}

#subnet
resource "aws_subnet" "subnetritson" {
  vpc_id = aws_vpc.estudos.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-west-2a"
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.estudos.id
}

#Create route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.estudos.id
}

#Associate route table with subnet
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnetritson.id
  route_table_id = aws_route_table.route_table.id
}
#Rota
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

#Criando a instancia
resource "aws_instance" "ubuntuestudos" {
  ami = "ami-02d8bad0a1da4b6fd"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnetritson.id
  key_name = "monitoramento"
  vpc_security_group_ids = [aws_security_group.ssh-rule.id]
    associate_public_ip_address = true
}

#Criando regras de acesso
resource "aws_security_group" "ssh-rule" {
  vpc_id = aws_vpc.estudos.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}



