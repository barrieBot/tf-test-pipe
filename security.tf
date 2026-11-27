resource "aws_security_group" "infc-elb-secgrp" {
  name        = "infc-elb-sg"
  description = "Security group for the INFC Load Balancer"
  vpc_id      = aws_vpc.infc-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# Define a new security group
resource "aws_security_group" "infc-web-secgrp" {
  name        = "infc-terrform-web-server"                                 # give it the following name
  description = "Security group for my INFC terraform web server instance" # add this description
  vpc_id      = aws_vpc.infc-vpc.id                                        # attach it to the following VPC which we just read the information form in the prior step

  ingress {
    from_port       = 80    # Defines the port in which incoming traffic will be allowed  
    to_port         = 80    # Same value as only port 80 is allowed
    protocol        = "tcp" # Allow traffic with the TCP protocol
    security_groups = [aws_security_group.infc-elb-secgrp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # no protocol constraint for outgoing traffic
    cidr_blocks = ["0.0.0.0/0"] # allow outbound traffic to all addresses 
  }

  # give it the name infc-web-secgrp
  tags = {
    "Name" = "infc-web-secgrp"
  }
}
