# 配置选项

在 `/data/haiwen/pro-data/seafevents.conf` 配置文件中：

```
[Audit]
## 审计日志默认是关闭的
enable = true

[INDEX FILES]
# 要启用搜索，必须设置为 "true"
enabled = true

# 搜索索引更新的时间间隔。可以是 s（秒）， m（分）， h（小时）， d（天）
interval=10m

# 如果设置为 "true"，搜索索引更新时也会索引办公文件和 pdf 文件中的内容
# 注意： 如果您将此选项从 "false" 设置为 "true"， 那么您需要清空搜索索引然后再次更新索引。更多详情请参考 FAQ。
index_office_pdf=false

[OFFICE CONVERTER]

# 要启用办公文件和 pdf 文件的在线预览功能必须设置为 "true"
enabled = true

# 能够并发运行的 libreoffice 工作进程数 
workers = 1

# 转换后的办公文件和 pdf 文件的存储位置
outputdir = /tmp/

# 允许的最大在线预览页数。默认为 50 页
max-pages = 50

# 允许的最大预览文件的大小，单位是 MB。默认为 2 MB
max-size = 2

[SEAHUB EMAIL]

# 要启用用户邮件通知，必须设置为 "true" 
enabled = true

# 发送 seahub 邮件的时间间隔。可以是 s（秒）， m（分）， h（小时）， d（天）
interval = 30m

```

### <a id="wiki-options-you-may-want-to-modify"></a>您可能想要更改的配置选项

以上小节已经列出了 `/data/haiwen/pro-data/seafevents.conf` 配置文件中的所有配置选项。大多数情况下，使用默认配置就足够了。但是为了更好地满足自身需求，您可能想要更改其中的某些选项。

我们将这些配置选项列出在下面的表中，以及我们选择默认设置的原因。

<table>
<tr>
<th>段</th>
<th>选项</th>
<th>默认值</th>
<th>描述</th>
</tr>

<tr>
<td>INDEX FILES</td>
<td>index_office_pdf</td>
<td>false</td>
<td>
默认情况下， office 文档和 pdf 文档的全文搜索功能是不开启的。这是因为它会占用相当大的搜索索引空间。要开启它，将它的值设置为 "true" 然后重新创建搜索索引。更多详情请参考 [[Seafile 专业版服务器的 FAQ]]。
</td>
</tr>

<tr>
<td>OFFICE CONVERTER</td>
<td>max-size</td>
<td>2MB</td>
<td>
允许的最大在线预览文件的大小是 2MB。在线预览会把 office 和 pdf 文档转换成 HTML 然后在浏览器中显示。如果文件太大，转换会花费很长时间且占用很多空间。
</td>
</tr>

<tr>
<td>OFFICE CONVERTER</td>
<td>max-pages</td>
<td>50</td>
<td>
当在线预览一个 office 或者 pdf 文档时，文档的前 50 页将会首先被显示。如果此值太大，转换会花费很长时间且占用很多空间。
</td>
</tr>

</table>
