#Set up repository for java installation
echo | sudo add-apt-repository ppa:webupd8team/java
#To be able to do silent java install
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
#install required packages
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install git mdadm oracle-java7-installer postfix ssl-cert xfsprogs -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'