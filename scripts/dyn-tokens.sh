# get ca-pin from auth

ca_pin=`tctl status | grep pin | awk -F' ' '{print $NF}'` 

echo $ca_pin > /vagrant/tokens/ca_pin

# proxy,node token
proxy_token=`sudo tctl nodes add --roles=proxy,node --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'`

echo $proxy_token > /vagrant/tokens/proxy_token

# node token
node_token=`sudo tctl nodes add --roles=node --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'`

echo $node_token > /vagrant/tokens/node_token


# create admin user
tctl create -f /vagrant/scripts/admin-user.yaml


# create trusted_cluster token

trusted_token=`sudo tctl tokens add --type=trusted_cluster --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'`

echo $trusted_token > /vagrant/tokens/trusted_token
