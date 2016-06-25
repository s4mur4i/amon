sudo sh -c 'echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_fin_timeout=15" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_max_syn_backlog=20480" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_max_tw_buckets=400000" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_no_metrics_save=1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_rmem=4096 65536 16777216" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_wmem=4096 65536 16777216" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_syn_retries=2" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.tcp_synack_retries=2" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.core.netdev_max_backlog=4096" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.core.somaxconn=4096" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf'
sudo sh -c 'echo "vm.min_free_kbytes=65536" >> /etc/sysctl.conf'