# Read the AWS AMI information
data "aws_ami" "ubuntu" {
  most_recent = true # it should be the most recent version of the image

  # filter for specific characteristics
  filter {
    name   = "name"                                                          # we look for the correct name
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # with the following value -> this will get the information for the latest Ubuntu 24.04 amd64 image
  }

  owners = ["099720109477"] #this is the ID of the Image owner, in this case Canonical
}

# Define the EC2 instance   
resource "aws_instance" "web-server" {
  count = length(aws_subnet.infc-pub-subnet)

  ami           = data.aws_ami.ubuntu.id # assign the AMI ID we just read  
  instance_type = var.instance_type      # assign the following instance type 

  subnet_id = aws_subnet.infc-pub-subnet[count.index].id

  vpc_security_group_ids = [
    aws_security_group.infc-web-secgrp.id
  ]

  associate_public_ip_address = true

  user_data                   = file("${path.module}/scripts/setup.sh") # Here we define the setup script to the instance -> this will be executed once the instance runs
  user_data_replace_on_change = true                                    # This flag makes sure the instance will be replaced if the script changes

  depends_on = [
    aws_route_table_association.infc-rt-subnet-link
  ]

  # give it the name infc-web-server
  tags = {
    Name = "infc-web-server-${count.index + 1}"
  }
}
