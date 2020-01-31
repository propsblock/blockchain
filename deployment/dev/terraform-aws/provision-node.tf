provider "aws" { 
    region          = "us-east-1"
}

resource "aws_vpc" "propsblock-chain-node-vpc" {
  cidr_block        = "172.16.0.0/16"
}

resource "aws_subnet" "propsblock-chain-node-subnet" {
  vpc_id            = aws_vpc.propsblock-chain-node-vpc.id
  cidr_block        = "172.16.10.0/24"
}

resource "aws_network_interface" "propsblock-chain-node-network" {
  subnet_id         = aws_subnet.propsblock-chain-node-subnet.id
  private_ips       = ["172.16.10.100"]
}

resource "aws_instance" "propsblock-chain-node-server" {
  ami               = "ami-09d069a04349dc3cb"
  instance_type     = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.propsblock-chain-node-network.id
    device_index         = 0
  }
}
