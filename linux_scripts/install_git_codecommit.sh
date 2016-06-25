sudo apt-get -y install build-essential fakeroot dpkg-dev liberror-perl git-man
mkdir ~/git-openssl
cd ~/git-openssl
apt-get -y source git
sudo apt-get -y build-dep git
sudo apt-get -y install libcurl4-openssl-dev
dpkg-source -x git_1.9.1-1ubuntu0.2.dsc
cd git-1.9.1
sudo find ~/git-openssl/git-1.9.1 -type f -print0 | xargs -0 sed -i 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/g'
sudo dpkg-buildpackage -rfakeroot -b
sudo dpkg -i ../git_1.9.1-1ubuntu0.2_amd64.deb