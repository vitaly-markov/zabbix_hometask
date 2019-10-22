#!/bin/bash

# installing from repo
# import GPG key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# add repo
sudo tee /etc/yum.repos.d/logstash.repo <<EOF
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
# install logstash
sudo yum install -y logstash
sudo yum clean all

# config logs
chmod -R 755 /opt/tomcat/logs/
sudo tee /etc/logstash/conf.d/tomcat8.conf <<EOF
input {
  file {
    path => "/opt/tomcat/logs/"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["192.168.56.169:9200"]
    index => "tomcat"
  }
}
EOF

sudo tee /etc/logstash/logstash.yml <<EOF
path.data: /var/lib/logstash
http.host: "192.168.56.170"
path.logs: /var/log/logstash
EOF

# enable & ran service
sudo systemctl start logstash.service
sudo systemctl enable logstash.service
