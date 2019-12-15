data "aws_vpc" "default" {
  default = true
}

data "http" "myip"{
    url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_connection" {
    name        = "allow_connection"
    description = "Allow all traffic to machine"
    vpc_id = data.aws_vpc.default.id

    
    ingress {
        # TCP (change to whatever ports you need)
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        # Please restrict your ingress to only necessary IPs and ports.
        # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
      }
      
    ingress {
        # TCP (change to whatever ports you need)
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        # Please restrict your ingress to only necessary IPs and ports.
        # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
      }
      
    ingress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = "true"
    }
      
      
    egress {
        # Outbound traffic is set to all
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}