resource "aws_instance" "elk-server" {
    # The connection block tells our provisioner how to
    # communicate with the resource (instance)
    
    instance_type = "t2.small"
    
    ami = var.ami-id
    
    key_name = var.keyname
    
    associate_public_ip_address = true
    
    
    security_groups = ["${aws_security_group.allow_connection.name}"]
    
    user_data = file("Scripts/install-docker.sh")
    
    
    tags = {
        Name        = "ELK Server"
        Created_On = formatdate("DD-MMM-YYYY hh:mm ZZZ", timestamp())
    }
    
    
}

resource "null_resource" "provision-server"{
    
    connection{
        type = "ssh"
        host = aws_instance.elk-server.public_ip
        user = var.user
        private_key = file("pem-file/${var.keyname}.pem")   
    }
    
    provisioner "remote-exec"{
        inline = [
                    "sudo mkdir -p /usr/persistent/elk-data",
                    "sudo chmod -R 777 /usr/persistent/elk-data"
        ]
    }
    
    provisioner "file"{
        source = "ConfigFiles/Dockerfile"
        destination = "/tmp/Dockerfile"
    }
    
    provisioner "file"{
        source = "ConfigFiles/02-beats-input.conf"
        destination = "/tmp/02-beats-input.conf"
    }
    
    provisioner "file"{
        source = "ConfigFiles/12-json.conf"
        destination = "/tmp/12-json.conf"
    }
    
    provisioner "file"{
        source = "ConfigFiles/30-output.conf"
        destination = "/tmp/30-output.conf"
    }
    
    provisioner "file"{
        source = "Scripts/runELKServer.sh"
        destination = "/tmp/runELKServer.sh"
    }
    
    provisioner "local-exec" {
      command = "sleep 120"
    }
    
    provisioner "remote-exec"{
        inline = [
                    "chmod +x /tmp/runELKServer.sh",
                    "sudo sh /tmp/runELKServer.sh"
        ]
    }
    
    depends_on = [
        aws_instance.elk-server
    ]
    
}

