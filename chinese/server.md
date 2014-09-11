# Seafile
## Seafile 服务器的组成

* Ccnet：网络服务
* Seafile server：负责数据访问
* Seahub：网站界面，供用户管理自己在服务器上的数据和账户信息
* FileServer: 负责直接从网站上下载和上传文件
* Controller: 负责监控和重启上述的部件

从概念上说，Seafile 服务器包含以上 5 个主要的部件。
