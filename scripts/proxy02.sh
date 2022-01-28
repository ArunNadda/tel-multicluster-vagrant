#! /bin/bash

# install teleport binary

apt install teleport

export capin=`cat /vagrant/tokens/ca_pin02`
export proxytoken=`cat /vagrant/tokens/proxy_token02`

echo "Creating auth node configuration ..."

# create teleport.yaml for auth node
tee /etc/teleport.yaml << EOF
teleport:
  nodename: teletron-proxy02
  auth_token: $proxytoken
  ca_pin: $capin
  auth_servers:
  - 10.0.0.56:3025
  data_dir: /var/lib/teleport
  log:
    output: /var/log/teleport/teleport.log
    severity: INFO
    format:
      output: text
proxy_service:
  enabled: "yes"
  web_listen_addr: 0.0.0.0:443
  https_keypairs:
  - key_file: /etc/teleport/ssl/proxy_key02.pem
    cert_file: /etc/teleport/ssl/proxy_full_chain02.crt
auth_service:
  enabled: "no"
ssh_service:
  enabled: "yes"
  labels:
    env: vagrant02
    host: proxy02
EOF


# teleport proxy service

tee /etc/systemd/system/teleport.service << EOF
[Unit]
Description="Teleport Proxy Node Service"
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
