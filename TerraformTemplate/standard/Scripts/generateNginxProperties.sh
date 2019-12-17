#!/bin/bash
cat > /etc/nginx/sites-available/kibana<<EOF1
server {
    listen *:90;
    server_name kibana;
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.kibana;
    
    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        }
}
EOF1