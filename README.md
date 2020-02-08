# 文档目录
  * [docker一键安装脚本]（#docker一键安装脚本）

# docker一键安装脚本

## Docker安装说明
1.支持centos7+

2.自动安装最新稳定版docker-ce docker-ce-cli containerd.io

3.服务开机自启动

# 使用前说明

## wget的安装

1. 如果系统没有wget，请先输入：yum -y install wget

## 国外服务器替换阿里源

```
wget http://raw.githubusercontent.com/limitrinno/docker/master/alirepo.sh && chmod +x alirepo.sh && ./alirepo.sh
```



#  脚本安装地址

## 脚本安装地址1--http

```
wget http://raw.githubusercontent.com/limitrinno/docker/master/install.sh && chmod +x install.sh && ./install.sh
```

## 脚本安装地址2--https

```
wget --no-check-certificate https://raw.githubusercontent.com/limitrinno/docker/master/install.sh && chmod +x install.sh && ./install.sh
```

