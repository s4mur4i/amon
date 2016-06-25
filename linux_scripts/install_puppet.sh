sleep 30,
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get remove ruby1.8 -y
sudo apt-get install ruby1.9.3 puppet -y