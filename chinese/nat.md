# Seafile
## Seafile 的几个组件（ccnet, seaf-server, fileserver, seahub) 分别需要各自的端口。如果服务器上使用了防火墙，则需要在防火墙中添加相应的规则，以保证 seafile 正常工作。


这些组件的端口都是可以在运行服务器初始化脚本(setup-seafile.sh)时设置、或者在执行seafile启动脚本(seafile.sh seahub.sh)时指定的。

## ccnet

* 默认端口: 10001
* 可以在运行初始化脚本时配置

## seaf-server

* 默认端口: 12001
* 可以在运行初始化脚本时配置

## seahub

* 默认端口: 8000
* 在启动时指定

## fileserver

* 默认端口: 8082
* 可以在运行初始化脚本时配置
