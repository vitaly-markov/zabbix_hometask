#!/bin/bash
sudo yum -y install java-1.8.0-openjdk.x86_64
sudo yum -y install java-devel
#installation tomcat
sudo mkdir /opt/tomcat
cd /tmp
wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz
tar -xf apache-tomcat-9.0.27.tar.gz
cp -r /tmp/apache-tomcat-9.0.27/* /opt/tomcat/

chmod +x /opt/tomcat/bin/*.sh
#Setup a Systemd unit file for Apache Tomcat
sudo cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload


cat << EOF > /opt/tomcat/bin/setenv.sh
export JAVA_OPTS="-Xms256m -Xmx512m -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=192.168.56.170"
EOF

#Adding Application
cp /vagrant/sample.war /opt/tomcat/webapps

systemctl start tomcat
systemctl enable tomcat