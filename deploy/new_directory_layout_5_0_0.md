# 5.0.0 版本中的配置文件位置改动

Seafile 服务器由几个组件组成，每个组件都有自己的配置文件。5.0 版本之前这些文件放在不同的目录下，管理起来不太方便。

5.0.0 之前的各个配置文件分布如下:

```sh
└── seahub_settings.py
└── ccnet/
    └── ccnet.conf
└── seafile/
    └── seafile.conf
└── conf/
    └── seafdav.conf
└── pro-data/
    └── seafevents.conf # (专业版)
└── seafile-server-latest/
```

5.0.0 之后，所有的配置文件都集中放置在 **conf** 目录下:

```sh
└── conf/
    └── ccnet.conf
    └── seafile.conf
    └── seafdav.conf
    └── seahub_settings.py
    └── seafevents.conf # (专业版)
└── ccnet/
└── seafile/
└── pro-data/
```

这样把所有的配置文件都集中放置，管理起来就更方便了。

当您升级到 Seafile 5.0.0 版本时，升级脚本会自动帮您把上述文件移到 **conf** 目录下面。
