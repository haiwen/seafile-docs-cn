# FAQ

#### 无法在网页上下载/上传文件

请检查下 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置选项是否正确设置。如果使用内置的 Web 服务器，监听在 8000 端口上，应该是
```
SERVICE_URL = http://IP:8000
FILE_SERVER_ROOT 选项不用配置
```

如果是使用 Nginx/Apache 为 Web 服务器，应该是
```
SERVICE_URL = http://IP
FILE_SERVER_ROOT = http://IP/seafhttp
```

如果还有问题，你可以使用 chrome/firefox 的调试模式来查看具体的错误信息。

#### 网页上显示 "Page unavailable", 该怎么解决?

* 请检查 logs/seahub_django_request.log 来查看具体的错误信息。

#### 安转完成后怎样修改 seafile-data 的位置?

Seafile 中使用 ccnet/seafile.ini 来记录 seafile-data 的位置

* 移动 seafile-data 到起来位置
* 修改 ccnet/seafile.ini 文件的内容

#### 发送邮件失败，怎么排查?

请检查 logs/seahub.log，常见错误如下：

1. 检查配置文件 seahub_settings.py 中的项目是否正确。比如忘了加引号， EMAIL_HOST_USER = XXX 应该改成 EMAIL_HOST_USER = 'XXX'
1. 邮件服务器不可用。

