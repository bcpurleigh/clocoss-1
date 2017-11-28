
# startup.sh numOfVms

vms=$1

if [ -z "$vms" ]
then
        echo "Please provide a number as a parameter."
        exit;
fi

if ! [[ "$vms" =~ ^[0-9]+$ ]]
then
        echo "The provided parameter must be an integer";
        exit;
fi

# Get root up in here
sudo su

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

#set secret keys
key=`openssl rand -base64 32`
echo "The secret key is $key, don't tell anyone!"

# get number of number of VMs

echo "The number of worker VMs to create is $vms"

# get server code from Git
git clone https://github.com/portsoc/clocoss-master-worker
cd clocoss-master-worker
npm install

# set google cloud server location
gcloud config set compute/zone europe-west1-d

# get external ip
externalIP=`curl -s -H "Metadata-Flavor: Google"  \
   "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip"`


# create vms
gcloud compute instances create  \
--machine-type f1-micro  \
--tags http-server,https-server  \
--metadata key=$key,ip=$externalIP  \
--metadata-from-file startup-script=startup-script.sh  \
`seq -f 'ben-worker-%g' 1 $vms`



gcloud compute instances delete `seq -f 'ben-worker-%g' 1 $vms`
