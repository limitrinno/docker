#/bin/bash
#By:cen制作
#Version:V1.0
#Update:2020-02-24

#----------基本变量----------
version1=`rpm -qa centos-release | grep release-7 | wc -l`
version2=`rpm -qa centos-release | grep release-6 | wc -l`
checkdockerinstall=`docker version | grep docker | wc -l`
checkfile1=`ls /etc/yum.repos.d/ | grep CentOS7-Base-163.repo | wc -l`
checkfile2=`ls /etc/yum.repos.d/ | grep CentOS6-Base-163.repo | wc -l`
#----------基本变量----------



#----------函数定义----------
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


#----------函数定义----------



#----------集成脚本主界面----------
printf "欢迎使用Limitrinno的集成脚本V1.0 \n"
echo "执行脚本前的编号即可运行对应脚本"
printf "============================\n"
echo "1.查询本机IP地址和详细地址信息"
echo "2.替换阿里源"
echo "3.***Centos7一键安装Docker稳定版***"
echo "4.实验-检测Wget是否安装"
echo "5.一键安装Aria2-外部脚本"
echo "6.一键安装SSR-外部脚本"
echo "7.一键安装Netdata-超炫酷的Linux监控软件"
echo "8.一键安装V2ray-外部脚本"
printf "============================\n"
echo -e "请输入你需要执行的脚本编号: \c"
read num
#----------集成脚本主界面----------



#----------判断语句----------
case $num in
	1)
	printf "开始查询你的IP地址，请稍等\n"
	curl cip.cc
	echo "查询完毕"
	;;

	2)
	if [[ $version1 -eq 1 && $checkfile1 -eq 0 ]]
	then
		echo "当前的系统版本为Centos7"
		checkyum
		echo "替换完成Centos7"
	elif [[ $version2 -eq 1 && $checkfile2 -eq 0 ]]
	then
		echo "当前的系统版本为Centos6"
		checkyum
		echo "替换完成Centos7"

	else
		echo "已经安装完成或者无法判断，暂时只支持Centos6或者7哦！"
	fi
	;;

	3)
	if [ $checkdockerinstall -eq 0 ]
	then
		dockerinstall
	else
		echo "Docker 已经安装"
	fi
	;;
	
	4)
	checkwget
	;;

	5)
	aria2install
	;;

	6)
	ssrinstall
	;;

	7)
	jkinstall
	;;

	8)
	v2rayinstall
	;;

	*) 
	echo "================================================"
	echo ”你输入的命令已经超出了地球的范围，请输入准确!“
	echo "================================================"
	;;

esac
#----------判断语句----------
