#! /bin/bash

echo "Creating auth node configuration ..."

# create teleport.yaml for auth node
tee /etc/teleport.yaml << EOF
teleport:
  nodename: teletron-auth02
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
    env: vagrant02
    node: auth-node02
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


# create trusted_cluster.yaml

# install teleport binary

export trustedtoken=`cat /vagrant/tokens/trusted_token`

echo "Creating trust_cluster.yaml..."

# create trust_cluster.yaml for 2nd cluster
# cluster teletron-auth will be root and teletron-auth02 will be leaf

tee /vagrant/scripts/trust_cluster.yaml << EOF
kind: trusted_cluster
version: v2
metadata:
  name: teletron-auth
spec:
  enabled: true
  token: $trustedtoken
  tunnel_addr: 10.0.0.15:3024
  web_proxy_addr: 10.0.0.15:443
  role_map:
    - remote: "access"
      local: ["access"]
EOF


# sleep 10 sec for next command/script
sleep 10
