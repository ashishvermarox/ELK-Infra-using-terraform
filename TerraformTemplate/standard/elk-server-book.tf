resource "aws_instance" "elk-server" {
    # The connection block tells our provisioner how to
    # communicate with the resource (instance)
    
    instance_type = "t2.small"
    
    ami = var.ami-id
    
    key_name = var.keyname
    
    associate_public_ip_address = true
    
    security_groups = ["${aws_security_group.allow_connection.name}"]
    
    
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
    
    provisioner "file"{
        source = "Scripts/elkSetup.sh"
        destination = "/tmp/elkSetup.sh"
    }
    
    provisioner "file"{
        source = "Scripts/generateElaticsearchProperties.sh"
        destination = "/tmp/generateElaticsearchProperties.sh"
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
        source = "ConfigFiles/kibana"
        destination = "/tmp/kibana"
    }
    
    provisioner "file"{
        source = "Scripts/generateKibanaProperties.sh"
        destination = "/tmp/generateKibanaProperties.sh"
    }
    
    provisioner "file"{
        source = "Scripts/generateNginxProperties.sh"
        destination = "/tmp/generateNginxProperties.sh"
    }
    
    provisioner "local-exec" {
      command = "sleep 5"
    }
    
    provisioner "remote-exec"{
        inline = [
                    "chmod +x /tmp/elkSetup.sh",
                    "sudo sh /tmp/elkSetup.sh"
        ]
    }
    
    depends_on = [
        aws_instance.elk-server
    ]
    
}

