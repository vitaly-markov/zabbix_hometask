#!/bin/bash

sudo yum install -y java
# installing from repo
# import GPG key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# add repo
sudo tee /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
# install elasticsearch
sudo yum install -y elasticsearch

chmod -R 755 /etc/elasticsearch



sudo tee /etc/elasticsearch/elasticsearch.yml <<EOF
transport.host: localhost
network.host: 192.168.56.169
http.port: 9200
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
EOF

# enable & ran service
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service
