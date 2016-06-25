sudo sh -c 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list'
wget -O- https://download.newrelic.com/548C16BF.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y newrelic-sysmond
sudo nrsysmond-config --set license_key=26788f58e00682cbbcb12aadfb3b476a8a467cb9
