#!/bin/bash -v

wget -q --show-progress --https-only --timestamping \
  "https://github.com/etcd-io/etcd/releases/download/v3.4.0/etcd-v3.4.0-linux-amd64.tar.gz"

tar -xvf etcd-v3.4.0-linux-amd64.tar.gz
sudo mv etcd-v3.4.0-linux-amd64/etcd* /usr/local/bin/

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
curl -s http://169.254.169.254/latest/meta-data/local-ipv4 > INTERNAL_IP.txt
curl -s http://169.254.169.254/latest/user-data/ | tr "|" "\n" | grep "^name" | cut -d"=" -f2 > ETCD_NAME.txt

echo "[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name $(cat ETCD_NAME.txt) \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://$(cat INTERNAL_IP.txt):2380 \\
  --listen-peer-urls https://$(cat INTERNAL_IP.txt):2380 \\
  --listen-client-urls https://$(cat INTERNAL_IP.txt):2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://$(cat INTERNAL_IP.txt):2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master-1=https://10.240.0.11:2380,master-2=https://10.240.0.12:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" >> etcd.service


sudo mv etcd.service /etc/systemd/system/etcd.service
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

