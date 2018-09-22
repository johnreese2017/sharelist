#!/bin/bash
#By moerats.com
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo "********************************"
echo "*      GDList 一键安装脚本     * "
echo "********************************"
echo ""

Font="\033[0m"
Blue="\033[33m"


# 检查系统版本
# check release
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

#安装环境
echo -e "${Blue}开始安装所需环境...${Font}"
# install node.js git pm2 curl
if [ "${release}" == "centos" ]; then
#关闭防火墙
systemctl stop firewalld.service >/dev/null 2>&1
systemctl disable firewalld.service >/dev/null 2>&1
service iptables stop >/dev/null 2>&1
chkconfig iptables off >/dev/null 2>&1
#开始安装
yum -y install curl git
curl -sL https://rpm.nodesource.com/setup_9.x | bash -
yum -y install nodejs
npm -g install npm@4
npm install -g pm2
else
apt-get -y install curl git
curl -sL https://deb.nodesource.com/setup_9.x | bash -
apt-get install -y nodejs
npm -g install npm@4
npm install -g pm2
fi

#安装GDList
echo -e "${Blue}开始安装GDList...${Font}"
git clone https://github.com/reruin/sharelist.git
cd sharelist
npm install yarn -g
yarn add pm2 -g
pm2 start bin/www
pm2 save
pm2 startup

#获取本机IP
IP=`curl http://whatismyip.akamai.com`

#输出结果
echo -e "${Blue}GDlist安装完成，请访问：http://${IP}:33001${Font}"
