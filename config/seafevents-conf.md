# seafevents.conf 配置

**注意**: Seafile 服务 5.0.0 之后，所有配置文件都移动到了统一的 **conf** 目录下。 [了解详情](../deploy/new_directory_layout_5_0_0.md).

在 `seafevents.conf` 配置文件中：

### 审计日志管理选项

```
[AUDIT]
## 审计日志默认是关闭的

enabled = true

[STATISTICS]
## 将 'enabled' 设置为 'true' 开启统计文件、已用空间、用户和流量等数据的功能；默认是关闭

enabled = true
```

### 搜索管理选项

```
[INDEX FILES]
## 要启用搜索，必须设置为 "true"

enabled = true

## 搜索索引更新的时间间隔。可以是 s（秒）， m（分）， h（小时）， d（天）

interval=10m

## 如果设置为 "true"，搜索索引更新时也会索引办公文件和 pdf 文件中的内容
## 注意： 如果您将此选项从 "false" 设置为 "true"， 那么您需要清空搜索索引然后再次更新索引。更多详情请参考 FAQ。

index_office_pdf=false

## 从 6.3.0 pro 开始，为了加快全文检索的速度，您还应该加上：
## 如果加上此配置项后发现搜索不到任何内容了，那么或许您应该重新构建搜索索引。

highlight = fvh
```

### 文件预览管理选项

```
[OFFICE CONVERTER]

## 要启用 office 文件和 pdf 文件的在线预览功能必须设置为 "true"
enabled = true

## 能够并发运行的 libreoffice 工作进程数 
workers = 1

## 转换后的办公文件和 pdf 文件的存储位置
outputdir = /tmp/

```

### 邮件通知管理选项

```
[SEAHUB EMAIL]

# 要启用用户邮件通知，必须设置为 "true" 
enabled = true

# 发送 seahub 邮件的时间间隔。可以是 s（秒）， m（分）， h（小时）， d（天）
interval = 30m

```