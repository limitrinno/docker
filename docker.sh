#/bin/bash
#Version: 2.0
#By Cen

#检查Docker是否安装
check_docker=`rpm -qa | grep docker | wc -l` &>/dev/null
#检查Bash是否设置上
limit=`tail /etc/profile | grep limitrinno | wc -l`
if [ $limit -eq 0 ];then
	echo "alias limit='sh /root/docker.sh'" >> /etc/profile
	source /etc/profile
fi

menu(){
cat <<-EOF
###############Limitrinno-一键脚本V2.0###############
#  QAQ:目前只支持Centos7+哦，目前只测试过Centos7    #
#  1.dockeAr					    #
#  q.exit					    #
#####################################################
EOF
}
menu


while :
do
	read -p "input num:" action
	case $action in
	1)
	if [ $check_docker -ne 0 ];then
		echo -e "\e[1;45mDocker容器好像已经安装完成了哦\e[0m"
	else
		yum remove docker docker-common docker-selinux docker-engine
		yum -y install yum-utils device-mapper-persistent-data lvm2
		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum -y install docker-ce docker-ce-cli containerd.io
		systemctl start docker && systemctl enable docker
		docker version
		echo -e "\e[1;45mDocker容器已经安装完成了哦\e[0m"
	fi
	break
	;;

	"")	;;
	q)	break;;
	*)	echo -e "\e[1;31mError!命令错误请重新输入\e[0m"
	esac
done

echo -e "\e[1;31m输入limit快速脚本\e[0m"
