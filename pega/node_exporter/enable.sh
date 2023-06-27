#!bin/bash

tee /home/pegauser/.config/systemd/user/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
ExecStart=/opt/pega/node_exporter/node_exporter
 
[Install]
WantedBy=default.target
EOF
