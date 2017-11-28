#!/bin/bash

#install git
sudo apt-get install git

# Change to what ever version you want here see link to versions below
sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Node is installed".

# install worker git code
git clone https://github.com/portsoc/clocoss-master-worker
cd clocoss-master-worker
npm install

#get metadata through
workkey=`curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/key"`
workserverIP=`curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ip"`

echo "$workkey is key and $workserverIP is ip."

# run client
npm run client $workkey $workserverIP:8080
