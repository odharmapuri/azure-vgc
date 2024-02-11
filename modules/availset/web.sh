sudo apt update
sudo apt install default-jdk wget -y
sudo update-java-alternatives -l
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.84/bin/apache-tomcat-9.0.84.tar.gz -P /tmp
sudo mkdir /opt/tomcat
sudo tar xf /tmp/apache-tomcat-*.tar.gz -C /opt/tomcat/ --strip-components=1

# sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
sudo chown -R azdemo:azdemo /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin

sudo ufw allow 8080

sudo cat > tomcat.service <<EOF
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=azdemo
Group=azdemo

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo tomcat.service /etc/systemd/system/tomcat.service

sudo rm -rf /opt/tomcat/webapps/ROOT/*
sudo cat > /opt/tomcat/webapps/ROOT/index.html <<EOF
<!DOCTYPE html>
<html>
<body>
<h1>Welcome to $(hostname)</h1>
<p>currtent timestamp is $(date)</p>
</body>
</html>
EOF
sudo cat /opt/tomcat/webapps/ROOT/index.html

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo systemctl status tomcat
#sudo systemctl restart tomcat