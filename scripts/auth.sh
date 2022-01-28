#! /bin/bash

echo "Creating auth node configuration ..."

# create teleport.yaml for auth node
tee /etc/teleport.yaml << EOF
teleport:
  nodename: teletron-auth
  data_dir: /var/lib/teleport
  log:
    output: /var/log/teleport/teleport.log
    severity: INFO
    format:
      output: text
auth_service:
  enabled: "yes"
  listen_addr: 0.0.0.0:3025
  tokens:
     - "proxy,node:hello"
  proxy_listener_mode: multiplex
ssh_service:
  enabled: "yes"
  labels:
    env: vagrant01
    node: auth-node
  #enhanced_recording:
  #  enabled: true
proxy_service:
  enabled: "no"
EOF



# copy teleport ent binary and install
apt install /vagrant/binaries/teleport-ent_8.1.1_arm64.deb -y

# copy ent license
cp /vagrant/license.pem /var/lib/teleport/license.pem

# Teleport Auth service

tee /etc/systemd/system/teleport.service << EOF
[Unit]
Description="Teleport Auth Node Service"
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/teleport.yaml

[Service]
PIDFile=/var/run/teleport.pid
Restart=on-failure
EnvironmentFile=-/etc/default/teleport
ExecStart=/usr/local/bin/teleport start --pid-file=/run/teleport.pid -d
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/teleport.pid
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload

systemctl start teleport

# sleep 10 sec for next command/script
sleep 10

# remove old tokens/pins

rm -f /vagrant/tokens/*
