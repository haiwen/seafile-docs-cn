# 防火墙 / NAT 设置

通过广域网(WAN)访问部署在局域网(LAN)的 Seafile 服务器,需要:

- 一台支持端口转发的路由器
- 使用动态域名解析服务
- 配置 Seafile 服务器


## 在路由器中设置端口转发

### 确保路由器支持端口转发功能

首先, 确保你的路由器支持端口转发功能：

- 根据路由器管理手册操作说明(或网络搜索), 进入路由器的管理用户界面。

- 找到包含 "转发" 或者 "高级" 等关键词的页面, 说明此路由器支持端口转发功能。

### 设置路由转发规则

Seafile 服务器包含两个组件， 请根据以下规则为 Seafile 组件设置端口转发。

<table>
<tr>
  <th>组件</th>
  <th>默认端口</th>
</tr>
<tr>
  <td>fileserver</td>
  <td>8082</td>
</tr>
<tr>
  <td>seahub</td>
  <td>8000</td>
</tr>
</table>

* 如果是在 Apache/Nginx 环境下部署的 Seafile, 则不需要打开 8000 和 8082 端口，只需要 80 或 443 端口即可。
* 以上是默认端口设置，具体配置可自行更改.

### 端口转发测试

设置端口转发后，可按以下步骤测试是否成功:

- 打开一个命令行终端
- 访问 `http://who.is` 得到本机的IP
- 通过以下命令连接 Seahub 
````
telnet <Your WAN IP> 8000
```

如果端口转发配置成功，命令行会提示连接成功。否则, 会显示 *connection refused* 或者 *connection timeout*， 提示连接不成功。

若未成功，原因可能如下:

- 端口转发配置错误
- 需要重启路由器
- 网络不可用

### 设置 SERVICE_URL 和 FILE_SERVER_ROOT

服务器依赖于 `ccnet.conf` 中的 "SERVICE_URL" 和 `seahub_setting.py` 中的 FILE_SERVER_ROOT 来生成文件的上传/下载链接。如果使用内置的 web 服务器，改为

```
SERVICE_URL = http://<Your WAN IP>:8000
```

如果配置了 Nginx, 则需要修改为 

```
SERVICE_URL = http://<Your WAN IP>
FILE_SERVER_ROOT = http://<Your WAN IP>/seafhttp
```

大部分路由器都支持 NAT loopback. 当你通过内网访问 Seafile 时, 即使使用外部 IP ，流量仍然会直接通过内网走。

## 使用域名解析服务

### 为什么使用动态域名解析服务?

完成以上端口转发配置工作后，就可以通过外网 IP 访问部署在局域网内的 Seafile 服务器了。但是对于大多数人来说， 外网 IP 会被 ISP (互联网服务提供商)定期更改, 这就使得，需要不断的进行重新配置.

可以使用动态域名解析服务来解决这个问题。通过使用域名解析服务，你可以通过域名（而不是 IP）来访问 Seahub，即使 IP 会不断变化，但是域名始终会指向当前 IP。

互联网上提供域名解析服务的有很多，我们推荐 [www.noip.com](http://www.noip.com)。

怎样使用域名解析服务，不在本手册说明范围之内，但是基本上，你需要遵循以下步骤:

1. 选择一个域名解析服务提供商。
2. 注册成为此服务商的一个用户。

## 更改 Seafile 配置

当你配置好域名解析服务之后，需要对 `ccnet.conf` 进行更改 (或者通过管理员 Web 界面来修改):

```
SERVICE_URL = http://<你的域名>:8000
```

然后重新 Seafile 服务.

## 网络设置

你如果使用内置的服务器，需要开启 8000 和 8082 两个端口。如果你的 Seafile 服务器是运行在 Nginx/Apache 环境下，并且开启了 HTTPS, 则需要开启 443 端口。


