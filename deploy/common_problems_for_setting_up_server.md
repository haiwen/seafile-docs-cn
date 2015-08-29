# 安装常见问题

#### 无法上传/下载

* 检查 ccnet.conf 中`SERVICE_URL`的配置，检查 seahub_settings.py 中`FILE_SERVER_ROOT`的配置 
* 确认防火墙没有禁用 seafile fileserver 
* 使用 chrome/firefox 调试模式,找到点击下载按钮时使用的链接并查看错误信息。



#### Apache 日志文件报错: "File does not exist: /var/www/seahub.fcgi"

请确定在 httpd.conf 或者 apache2.conf 中使用了`FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000` 尤其是`/var/www/seahub.fcgi`部分.

#### Apache/HTTPS 下，Seafile 只显示文本文件(没有 CSS 样式和图片显示)

多媒体文件访问权限错误 (Alias location identified in /etc/apache2/sites-enabled/000-default (Ubuntu)

解决方法:

1. 切换到非根（non-root）用户重新运行安装脚本
2. 复制`/media`文件夹到`var/www/`下，并在`/etc/apache2/sites-enabled/000-default`中重新编辑文件路径。

#### 初始化 Seafile 时，显示 "Error when calling the metaclass bases" 错误

Seafile 使用 Django 1.5, 所需 Python 版本为 2.6.5+ 。
