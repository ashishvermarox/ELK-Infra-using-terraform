resource "aws_instance" "elk-client" {
    # The connection block tells our provisioner how to
    # communicate with the resource (instance)
    
    instance_type = "t2.micro"
    
    ami = var.ami-id
    
    key_name = var.keyname
    
    associate_public_ip_address = true
    
    security_groups = ["${aws_security_group.allow_connection.name}"]
    
    user_data = file("Scripts/install-filebeat.sh")
    
    tags = {
        Name        = "ELK Client"
        Created_On = formatdate("DD-MMM-YYYY hh:mm ZZZ", timestamp())
    }
}

resource "null_resource" "provision-client"{
    
    connection{
        type = "ssh"
        host = aws_instance.elk-client.public_ip
        user = var.user
        private_key = file("pem-file/${var.keyname}.pem")   
    }
    
    provisioner "remote-exec"{
        inline = [
                    "sudo mkdir -p /tmp/sample_logs",
                    "sudo mkdir -p /etc/pki/tls/certs",
                    "sudo chmod -R 777 /tmp/sample_logs",
                    "sudo chmod -R 777 /etc/pki/tls/certs"
        ]
    }
    
    provisioner "file"{
        source = "ConfigFiles/sample_log.json"
        destination = "/tmp/sample_logs/sample_log.json"
    }
    
    provisioner "file"{
        source = "ConfigFiles/logstash-beats.crt"
        destination = "/etc/pki/tls/certs/logstash-beats.crt"
    }
    
    provisioner "file"{
        source = "Scripts/filebeat.sh"
        destination = "/tmp/filebeat.sh"
    }
    
    provisioner "file"{
        source = "Scripts/filebeatRegistryClean.sh"
        destination = "/tmp/filebeatRegistryClean.sh"
    }
    
    provisioner "local-exec" {
      command = "sleep 30"
    }
    
    provisioner "remote-exec"{
        inline = [
                    "chmod +x /tmp/filebeat.sh",
                    "chmod +x /tmp/filebeatRegistryClean.sh",
                    "sudo sh /tmp/filebeat.sh ${aws_instance.elk-server.private_ip}",
                    "sudo sh /tmp/filebeatRegistryClean.sh"
        ]
    }
    
    depends_on = [
        null_resource.provision-server,
        aws_instance.elk-client
    ]
    
}

