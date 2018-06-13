#!/bin/bash

apt-get update -y
apt-get install -y haproxy
cat >> /etc/haproxy/haproxy.cfg << EOF

frontend http_front
    bind *:80
    mode http
    option http-keep-alive
    default_backend service2_back

backend service2_back
    mode http
    balance roundrobin
    option http-keep-alive
#    http-reuse safe
    server docker-vm-service2v1 172.17.17.6:8882
    server docker-vm-service2v2 172.17.17.7:8882
EOF
systemctl restart haproxy