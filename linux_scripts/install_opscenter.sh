#Set up repository for opscenters installation
echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.community.list
curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
#Set up repository for java installation
echo | sudo add-apt-repository ppa:webupd8team/java
#To be able to do silent java install
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections

#install required packages
sudo apt-get update
sudo apt-get -y install opscenter git oracle-java7-installer