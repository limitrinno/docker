#/bin/bash
#By:cen制作
#Version:V1.0
#Update:2020-03-13

#----------集成脚本主界面----------
echo "欢迎使用Limitrinno的集成脚本V2.0"
echo "执行脚本前的编号即可运行对应脚本"
echo "脚本仅在Centos7下测试，其他系统自行排错"
echo "=================================="
echo ""
echo "----------简易脚本----------"
echo "101.查询本机IP地址和详细地址信息"
echo "102.Centos6+替换阿里源(有BUG)"
echo "103.Centos7一键安装Docker稳定版"
echo "----------简易脚本----------"
echo ""
echo "因为pull的国内速度太慢了"
echo "所以需要本地的Socks来代理下载"
echo "最后还不如自己搭建一个软路由来的实际"
echo "----------Socks5脚本----------"
echo "201.配置系统bash下的Socks5,输入完成按照提示操作"
echo "202.配置Docker的Socks5代理(自动)"
echo "203.配置Docker的加速器(阿里云加速器),Kill掉，写着好看不删了"
echo "----------Socks5脚本----------"
echo ""
echo "----------外部脚本----------"
echo "301.一键安装Aria2-外部脚本"
echo "302.一键安装SSR-外部脚本"
echo "303.一键安装Netdata-超炫酷的Linux监控软件"
echo "304.一键安装V2ray-外部脚本(需要编译)"
echo "305.一键安装233Boy-V2ray-外部脚本(推荐)"
echo "----------外部脚本----------"
echo "=================================="
echo ""
read -p "请输入上面的代码选项:" num

#----------集成脚本主界面----------


#----------函数定义----------
checkdockerinstall=`docker version | grep docker | wc -l`
version1=`rpm -qa centos-release | grep release-7 | wc -l`
version2=`rpm -qa centos-release | grep release-6 | wc -l`
checkfile1=`ls /etc/yum.repos.d/ | grep CentOS7-Base-163.repo | wc -l`
checkfile2=`ls /etc/yum.repos.d/ | grep CentOS6-Base-163.repo | wc -l`
checkfile1=`ls /root | grep bashsocks5.sh | wc -l`
checkfile2=`ls /etc/systemd/system | grep docker.service.d | wc -l`
#checkfile2=`ls /etc/systemd/system/docker.service.d | grep http-proxy.conf | wc -l`

#阿里yum源
checkyum(){
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
cd /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum clean all
yum makecache
}

#Docker安装
dockerinstall(){
yum remove docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker && systemctl enable docker
docker version
echo "Docker 已经安装完成，开始使用吧!"
}

#检查系统是否安装了Wget
checkwget(){
echo "正在检查是否安装Wget"
str1=`rpm -qa | grep wget | wc -l`
if [ $str1 == 0 ]
then
	echo "没有安装Wget呢！"
	yum -y install wget
	echo "Wget 安装完成"
else
	echo "Wget 安装完成"
fi
}

#外部脚本-aria2
aria2install(){
checkaria=`ls . | grep aria2.sh | wc -l`
if [ $checkaria -eq 0 ]
then
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/aria2.sh && chmod +x aria2.sh && bash aria2.sh
else
	sh aria2.sh
fi
}

#外部脚本-SSR
ssrinstall(){
checkssr=`ls . | grep ssr.sh | wc -l`
if [ $checkssr -eq 0 ]
then
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
else
	sh ssr.sh
fi
}

#Netdata官方脚本
jkinstall(){
	bash <(curl -Ss https://my-netdata.io/kickstart.sh)
}

#外部脚本-V2ray一键安装
v2rayinstall(){
checkv2ray=`ls . | grep install.sh | wc -l`
if [ $checkv2ray -eq 0 ]
then
	wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/master/install.sh" && chmod +x install.sh && bash install.sh
else
	sh install.sh
fi
}

#本地local-bash脚本
addbash(){
echo "正在配置"
read -p "请输入的局域网IP:(默认IP为10.10.10.1)" ip
ip=${ip:-10.10.10.1}
read -p "请输入Socks5的端口:(默认端口为10800)" sport
sport=${sport:-10800}
read -p "请输入Http的端口:(默认端口为10801)" hport
hport=${hport:-10801}
touch /root/bashsocks5.sh
chmod o+x bashsocks5.sh
echo "export ALL_PROXY=socks5://$ip:$sport" >> /root/bashsocks5.sh
echo "export http_proxy="http://$ip:$hport"" >> /root/bashsocks5.sh
echo "export https_proxy="https://$ip:$hport"" >> /root/bashsocks5.sh
echo "正在应用临时的配置文件"
source /root/bashsocks5.sh
sh /root/bashsocks5.sh
echo "查看配置文件:"
cat /root/bashsocks5.sh
echo "开始查询是否代理成功"
curl cip.cc
echo "查询地址是否为自己的IP,如果不是执行下面的命令"
echo "source /root/bashsocks5.sh"
}

#Docker本地脚本
socks5(){
echo "正在配置内网的socks5"
read -p "请输入的局域网IP:(默认IP为10.10.10.1)" ip
ip=${ip:-10.10.10.1}
read -p "请输入Socks5的端口:(默认端口为10800)" sport
sport=${sport:-10800}
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment="HTTP_PROXY=socks5://$ip:$sport/"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo "正在检查proxy的配置文件"
cat /etc/systemd/system/docker.service.d/http-proxy.conf
echo "你的Socks5以及创建完成，正在重启Docker"
sudo systemctl daemon-reload
systemctl restart docker
echo "结果如下:"
systemctl show --property=Environment docker
echo "Success!"
}

#----------函数定义----------


#----------判断语句----------
case $num in
	101)
	printf "开始查询你的IP地址，请稍等\n"
	curl cip.cc
	echo "查询完毕"
	;;

	102)
	if [[ $version1 -eq 1 && $checkfile1 -eq 0 ]]
	then
		echo "当前的系统版本为Centos7"
		#checkyum
		echo "替换完成Centos7"
	elif [[ $version2 -eq 1 && $checkfile2 -eq 0 ]]
	then
		echo "当前的系统版本为Centos6"
		#checkyum
		echo "替换完成Centos6"

	else
		echo "已经安装完成或者无法判断，暂时只支持Centos6或者7哦！"
	fi
	;;

	103)
	if [ $checkdockerinstall -eq 0 ]
	then
		dockerinstall
	else
		echo "Docker 已经安装"
	fi
	;;
	
	301)
	aria2install
	;;

	302)
	ssrinstall
	;;

	303)
	jkinstall
	;;

	304)
	v2rayinstall
	;;

	201)
	if [ $checkfile1 -eq 0 ]
	then
		addbash
	else
		rm -rf /root/bashsocks5.sh
		addbash
	fi
	;;

	202)
	if [ $checkfile2 -eq 0 ]
	then
		socks5
	else
		rm -rf /etc/systemd/system/docker.service.d/*
		socks5
	fi
	;;

	203)
	echo "功能未开放"
	;;

	305)
	bash <(curl -s -L https://233v2.com/v2ray.sh)
	;;

	*) 
	echo "================================================"
	echo ”你输入的命令已经超出了地球的范围，请输入准确!“
	echo "================================================"
	;;

esac
#----------判断语句----------
