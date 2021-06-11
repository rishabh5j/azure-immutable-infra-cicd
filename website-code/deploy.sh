sudo mkdir -p /home/rijain/website-code
sudo apt update
sudo apt install python3-pip --assume-yes
sudo cp -r /deployTemp/website-code/* /home/rijain/website-code/
sudo pip3 install --requirement /home/rijain/website-code/requirements.txt
sudo echo '[Unit]
Description=Flask website

[Service]
Type=simple
ExecStart=/usr/bin/python3 /home/rijain/website-code/main.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/website.service
sudo systemctl daemon-reload
sudo systemctl enable website.service