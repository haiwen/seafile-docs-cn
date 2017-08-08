# 日志

### Seafile 服务器有如下日志文件:

* seafile.log: Seafile服务器的日志
* controller.log: 控制器的日志
* seahub_django_request.log: Seahub的日志
* seahub.log: Django 框架和电子邮件发送的日志
* Ccnet Log: logs/ccnet.log  (内部 RPC 的日志, 没有实际用处)

### 专业版特有日志文件：

* seafevents.log: 后台任务和 office 文件转换的的日志
* seahub_email_sender.log: 定期发送后台任务的日志

### 集群模式下后端节点日志文件：

* seafile.log: Seafile服务器的日志
* controller.log: 控制器的日志
* seahub_django_request.log: Seahub的日志
* seahub.log: Django 框架和电子邮件发送的日志
* seafevents.log: 空
* seafile-background-tasks.log: 后台任务和 office 文件转换的的日志
* seahub_email_sender.log: 定期发送后台任务的日志
* Ccnet Log: logs/ccnet.log  (内部 RPC 的日志, 没有实际用处)