#Seafile
##Seafile 数据备份指南

Seafile 运行相关的数据都在安装目录下，所以只需要将整个安装目录进行备份即可。

我们使用一台闲置的机器作为备份，在该机器上使用rsync命令将机器A上的seafile安装目录同步过来。命令如下：

    mkdir /backup

    rsync -azv --delete user@A:/path/to/your/seafile /backup/

如果需要定期执行备份（例如，每天凌晨3点），可以在备份机器上加入一项定时任务。

    crontab -e

然后写入以下规则，并保存使规则生效。

    0 3 * * * rsync -azv --delete user@A:/path/to/your/seafile /backup/
