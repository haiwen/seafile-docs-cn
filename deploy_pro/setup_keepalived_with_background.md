# 高可用seafile后端节点

## 配置keepalived服务

在每个seafile后端节点上安装和配置 keepalived 来实现浮动 IP 地址。

CentOS 7:
```
yum install keepalived -y
```

假设配置了两个seafile后端节点：background1、background2

在background1上修改 keepalived 配置文件(/etc/keepalived/keepalived.conf),写入如下内容：

```
! Configuration File for keepalived

global_defs {
    notification_email {
        root@localhost
    }
    notification_email_from keepalived@localhost
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id background1
    vrrp_mcast_group4 224.0.100.18
}

vrrp_instance VI_1 {
    state MASTER
    interface eno16777736
    virtual_router_id 52
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass hello123
    }
    virtual_ipaddress {
        172.26.154.43/24 dev eno16777736
    }
    notify_master "/opt/seafile/seafile-server-latest/seafile-background-tasks.sh start"
    notify_backup "/opt/seafile/seafile-server-latest/seafile-background-tasks.sh stop"
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
    router_id background2
    vrrp_mcast_group4 224.0.100.18
}

vrrp_instance VI_1 {
    state BACKUP
    interface eno16777736
    virtual_router_id 52
    priority 98
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass hello123
    }
    virtual_ipaddress {
        172.26.154.43/24 dev eno16777736
    }
    notify_master "/opt/seafile/seafile-server-latest/seafile-background-tasks.sh start"
    notify_backup "/opt/seafile/seafile-server-latest/seafile-background-tasks.sh stop"
}
```

 * 注意：以上配置中`interface`指定该节点的网卡设备名称，请根据实际情况配置。`virtual_ipaddress`配置HAproxy集群的虚拟IP地址，也需要根据实际情况配置。

分别在两个后端节点上重启keepalived服务：

```
systemctl restart keepalived.service
```

重启成功后查看background1节点是否成功启用了相应的VIP。

## 修改seafile前端服务器相关配置

当配置好keepalived实现了虚拟IP漂移后，需要将seafile前端服务器里的相关配置指向后端服务器的虚拟IP。
在各seafile前端服务器节点上：
编辑`seafevents.conf`，修改以下配置信息：

```
[INDEX FILES]
...
es_host = <vip of nodes background>
...
```

编辑`seahub_settings.py`，修改以下配置信息：

```
...
OFFICE_CONVERTOR_ROOT = 'http://<vip of nodes background>'
...
```

* 注意：以上配置文件中的`'vip'`指的是keepalived服务上配置的虚拟IP地址。

重启前端节点上的seafile、seahub服务：

```
./seafile.sh restart
./seahub.sh restart-fastcgi
```