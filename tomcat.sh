 #!/bin/bash
tomcat_home=/opt/ClusterA/
SHUTDOWN=$tomcat_home/bin/shutdown.sh
STARTTOMCAT=$tomcat_home/bin/startup.sh
back_name=$(date +%Y%m%d)
echo $2 $1 $tomcat_home
case $1 in
start)
echo "启动$tomcat_home"
$STARTTOMCAT
tail -f $tomcat_home/logs/catalina.out
;;
stop)
echo "关闭$tomcat_home"
$SHUTDOWN
ps -ef |grep tomcat |grep $tomcat_home |grep -v 'grep'|awk '{print $2}' | xargs kill -9
#删除日志文件，如果你不先删除可以不要下面一行
rm $tomcat_home/logs/* -rf
#删除tomcat的临时目录
rm $tomcat_home/work/* -rf
;;
restart)
echo "关闭$tomcat_home"
$SHUTDOWN
ps -ef |grep tomcat |grep $tomcat_home |grep -v 'grep'|awk '{print $2}' | xargs kill -9
#删除日志文件，如果你不先删除可以不要下面一行
rm $tomcat_home/logs/* -rf
#删除tomcat的临时目录
rm $tomcat_home/work/* -rf
sleep 5
echo "启动$tomcat_home"
echo "查看日志-----------------------------------查看日志"
$STARTTOMCAT
#看启动日志
tail -f $tomcat_home/logs/catalina.out
;;
logs)
echo "查看日志-----------------------------------查看日志"
tail -f $tomcat_home/logs/catalina.out
;;
back)
echo "开始备份-----------------------------------开始备份"
mkdir -p /datafile/archive-packages/$back_name
cp -r $tomcat_home/webapps/ /datafile/archive-packages/$back_name/
sleep 3
ls /datafile/archive-packages/$back_name/
echo "完成备份--------------------------------完成备份"
esac
