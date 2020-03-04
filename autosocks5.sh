#/bin/bash
#by Cen


# =================== 函数配置 ===================

checkfile1=`ls /root | grep bashsocks5.sh | wc -l`
checkfile2=`ls /etc/systemd/system/docker.service.d | grep http-proxy.conf | wc -l`

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

# =================== 函数配置 ===================


# =================== Default 传参  ===================
#if [ -z "$ip" ];then
#	ip='192.168.1.1'
#fi

#if [ -z "$sport" ];then
#	sport=10800
#fi

#if [ -z "$hport" ];then
#	hport=10801
#fi
# =================== Default 传参  ===================



# =================== 主UI界面  ===================

#echo "-------------------------------------------------"
#echo "这是一个自动更换docker的socks5的脚本"
#echo ""
#read -p "请在输入socks5的内网地址或者公网地址:(默认:192.168.1.1)" ip
#echo ""
#echo "常规的Ssr或者V2ray"
#echo "Socks5分别为1080 and 10800"
#echo "Http和Https分别为1080 and 10801"
#echo ""
#read -p "请输入Socks5的端口:(回车默认10800)" sport
#echo ""
#read -p "请输入http和https的端口:(回车默认10801)" hport
#echo "-------------------------------------------------"

echo "这是一个简单的Socks一键切换程序"
echo "---------- ---------- ---------- ----------"
echo "1.配置系统bash下的Socks5,仅在当前的界面生效，退出失效"
echo "2.配置Docker的Socks5代理,开启局域网代理时生效,不开启默认"
echo "3.配置Docker的加速器(阿里云加速器),感觉用处不是很大"
echo "---------- ---------- ---------- ----------"
read -p "请输入上面的代码选项:" num

# =================== 主UI界面  ===================



# =================== 条件判断 以及输出  ===================

case $num in
	1)
	if [ $checkfile1 -eq 0 ]
	then
		addbash
	else
		rm -rf /root/bashsocks5.sh
		addbash
	fi
	;;

	2)
	if [ $checkfile2 -eq 0 ]
	then
		socks5
	else
		rm -rf /etc/systemd/system/docker.service.d/*
		socks5
	fi
	;;

	3)
	echo "功能未开放"
	;;

	*)
	echo "不存在的选项,重新执行脚本"
	;;
esac

# =================== 条件判断 以及输出  ===================

