upstream nginxServers {
    server 10.60.1.2;
}

proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=upstream_cache:20m inactive=5m max_size=2G;

server {
    listen 80;
    root /www/data;
    server_name localhost;
    access_log /var/log/nginx/map.access.log combined;
    error_log /var/log/nginx/map.error.log notice;  
    proxy_cache_key $scheme$host$request_uri;
    add_header X-Cache-Status $upstream_cache_status;  

    location / {
        proxy_pass http://nginxServers;
        proxy_cache upstream_cache;
        proxy_cache_valid 200 5m;
    }
    location /images/ {
    }
    
}