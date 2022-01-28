
# Vagrantfile and Scripts to Automate teleport cluster installation

# this repo is to setup 2 telport cluster (with auth and proxy on separate nodes).
# It also covers how to setup truster cluster.

**NOTE**: this vagrant file is setup for mac m1, which considers working Vagrant (with vmware fusion). Ref: https://gist.github.com/sbailliez/f22db6434ac84eccb6d3c8833c85ad92

## Prerequisites

1. Working Vagrant setup
2. 8 Gig + RAM workstation as the Vms use 5 vCPUS and 5+ GB RAM
 
## Usage/Examples

To provision the clusters, execute the following commands.

```shell
git clone https://github.com/ArunNadda/tel-multicluster-vagrant.git
cd tel-multicluster-vagrant
vagrant up
```


## To shutdown the clusters, 

```shell
vagrant halt
```

## To restart the cluster,

```shell
vagrant up
```

## To destroy the cluster, 

```shell
vagrant destroy -f
```



# More info

### clusters
This setup will create 5 nodes. 

- cluster1 : auth, proxy, sshnode
- cluster2: auth02, proxy02

```shell
10.0.0.15  proxy-node
10.0.0.16  auth-node
10.0.0.200  ssh-node
10.0.0.55  proxy-node02
10.0.0.56  auth-node02
```

- both proxy clusters are using selfsigned certifictes which are stored at ./tls/. To access proxy from mac browser, both root and intermediate-root CA shall be imported to keychain using below commands:

```shell
 % sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./tls/CAvagrant01_cert.crt

 % sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./tls/pki1.cert.crt
```

- teleport process is using ent binary for `auth` and `auth02` nodes. A license file (`license.pem`) is required to be present at directory `tel-multicluster-vagrant`.

- put teleport ent pkg at `tel-multicluster-vagrant/binaries`.

```
% pwd
./tel-multicluster-vagrant/binaries
binaries % ls
README.md
teleport-ent_8.1.1_arm64.deb

```

- all other nodes are using OSS teleport binary.

- Vagrant is using `"shell", path:` option to run scripts on VMs. these scripts are using to setup `/etc/teleport.yaml`, teleport service and tokens etc.

- Access cluster 

**cluster1**
https://10.0.0.15

**cluster2**
https://10.0.0.56




# to setup trusted cluster

- trusted cluster yaml is already geneared.
- Token for same is also genarated but has ttl of 30m. If creating trusted clusters after 30min of creation of `auth` node, create a new `token` using below command and add this to `trusted_cluster.yaml` location under `./scripts`.

```shell
sudo tctl tokens add --type=trusted_cluster --ttl=30m | grep invite | awk -F': ' '{print $NF}' | awk -F'.' '{print $1}'
```

- run below command on cluster2:

```shell
# on auth02
tctl create -f trust_cluster.yaml
```

