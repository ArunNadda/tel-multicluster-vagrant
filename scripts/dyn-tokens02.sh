# get ca-pin from auth

ca_pin=`tctl status | grep pin | awk -F' ' '{print $NF}'` 

echo $ca_pin > /vagrant/tokens/ca_pin02

# proxy,node token
proxy_token=`sudo tctl nodes add --roles=proxy,node --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'`

echo $proxy_token > /vagrant/tokens/proxy_token02

# node token
node_token=`sudo tctl nodes add --roles=node --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'`

echo $node_token > /vagrant/tokens/node_token02


# create admin user
tctl create -f /vagrant/scripts/admin-user.yaml
