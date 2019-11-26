# docker
docker一键安装 支持centos7，自动更换阿里yum源，自动安装稳定版docker-ce，加入自启动

# 使用前先 yum -y install wget

# HTTP协议下载安装
wget http://raw.githubusercontent.com/limitrinno/docker/master/install.sh && chmod +x install.sh && ./install.sh

# HTTPS协议下载安装
wget --no-check-certificate https://raw.githubusercontent.com/limitrinno/docker/master/install.sh && chmod +x install.sh && ./install.sh
