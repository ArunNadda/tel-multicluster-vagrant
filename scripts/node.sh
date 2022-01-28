#! /bin/bash

export capin=`cat /vagrant/tokens/ca_pin`
export proxytoken=`cat /vagrant/tokens/node_token`

# install teleport binary
apt install teleport


echo "Creating ssh node configuration ..."

# create teleport.yaml for auth node
tee /etc/teleport.yaml << EOF
teleport:
  nodename: teletron-node
  auth_servers:
  - 10.0.0.16:3025
  ca_pin: $capin
  auth_token: $proxytoken
  data_dir: /var/lib/teleport
  log:
    output: /var/log/teleport/teleport.log
    severity: INFO
    format:
      output: text
proxy_service:
  enabled: "no"
auth_service:
  enabled: "no"
ssh_service:
  enabled: "yes"
  labels:
    env: example
  commands:
  - name: hostname
    command: ['hostname']
    period: 1m0s
EOF


# Teleport service

tee /etc/systemd/system/teleport.service << EOF
[Unit]
Description="Teleport agent Service"
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
