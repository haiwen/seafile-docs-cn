# 高可用 HAproxy 节点
在每个 HAproxy 节点上安装和配置 keepalived 来实现浮动 IP 地址。

CentOS 7:
```
yum install keepalived
```

假设配置了两个 HAproxy 节点：node1、node2

在node1上修改 keepalived 配置文件(/etc/keepalived/keepalived.conf),写入如下内容：

```
! Configuration File for keepalived

global_defs {
	notification_email {
		root@localhost
	}
	notification_email_from keepalived@localhost
	smtp_server 127.0.0.1
	smtp_connect_timeout 30
	router_id node1
	vrrp_mcast_group4 224.0.100.19
}

vrrp_instance VI_1 {
    state MASTER
    interface eno16777736
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass hello123
    }
    virtual_ipaddress {
        172.26.154.45/24 dev eno16777736
    }
}
```

在node2上修改 keepalived 配置文件(/etc/keepalived/keepalived.conf),写入如下内容：

```
! Configuration File for keepalived

global_defs {
	notification_email {
		root@localhost
	}
	notification_email_from keepalived@localhost
	smtp_server 127.0.0.1
	smtp_connect_timeout 30
	router_id node2
	vrrp_mcast_group4 224.0.100.19
}

vrrp_instance VI_1 {
    state BACKUP
    interface eno16777736
    virtual_router_id 51
    priority 98
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass hello123
    }
    virtual_ipaddress {
        172.26.154.45/24 dev eno16777736
    }
}
```

 * 注意：以上配置中`interface`指定该节点的网卡设备名称，请根据实际情况配置。`virtual_ipaddress`配置HAproxy集群的虚拟IP地址，也需要根据实际情况配置。

 ## 修改 SERVICE_URL 和 FILE_SERVER_ROOT

下面还需要更新 SERVICE_URL 和 FILE_SERVER_ROOT 这两个配置项。否则无法通过 Web 正常的上传和下载文件。

5.0 版本开始，您可以直接通过管理员 Web 界面来设置这两个值 (注意，如果同时在 Web 界面和配置文件中设置了这个值，以 Web 界面的配置为准。建议在Web界面修改此配置。)：
```
SERVICE_URL: http://<ip of virtual_ipaddress>
FILE_SERVER_ROOT: http://<ip of virtual_ipaddress>/seafhttp
```