# Seafile
## 这篇帮助文档介绍了服务器的管理员如何更改 Seafile 服务器的配置。这里假设你已经完成了 [对服务器的第一次配置](deploy.md)。

## Seafile 的网络配置 (ccnet.conf)

你可以通过修改 ccnet/ccnet.conf 文件中的选项来控制 Seafile 的网络参数。下面我们通过一个示例配置来介绍可配置的选项。

<pre>
[General]

# 这个在服务器上没有用
USER_NAME=example

# 请不要更改这个 ID
ID=eb812fd276432eff33bcdde7506f896eb4769da0

# NAME 会被同步到客户端上，做为服务器的名字
NAME=example

# SERVICE_URL 应该设置为 Seahub(Seafile 网站)的 URL
SERVICE_URL=http://www.example.com:8000


[Network]

# 这个端口用于 Seafile 客户端的连接。如果这个端口号已经有其他进程使用，请更改
PORT=10001

[Client]
# Ccnet 会在 localhost 上监听这个端口，以响应本地客户端的服务调用请求（比如 Seahub 网站）。
# 如果该端口号已经有其他进程使用，会导致 Ccnet 和 Seafile 无法启动，此时请更改这个设置
PORT=13419

</pre>

'''Note''': 在更改了 ccnet.conf 之后，你需要重启 Seafile 以使得设置生效。

<pre>
cd seafile-server
./seafile.sh restart
</pre>

## 存储容量限制 (seafile.conf)

你可以为所有用户设定一个默认的容量上限。这只需要在 seafile-data/seafile.conf 文件中加入以下几行：

<pre>
[quota]
# 以 GB 为单位的容量上限，只接受整数
default = 2
</pre>

如果你想给某个特定用户设置容量上限，你可以用管理员身份登录 seahub 网站，然后在“系统管理”页面中设置。

## Seafile fileserver配置 (seafile.conf)

Seafile fileserver 的配置在<code>seafile-data/seafile.conf</code>里的<code>[fileserver]</code>段。

如果你需要为fileserver指定其他端口，或者要启动https，则需要修改fileserver的配置。关于如何为Seahub和fileserver开启https，请参考 [[Seafile web界面启用Https]]。

<pre>
[fileserver]
# tcp port for fileserver
port = 8082
# use https or not
https=true
# if https is used, the path to the SSL pemfile and privkey must be provided.
pemfile=/path/to/ssl/pemfile/
privkey=/path/to/ssl/privkey
</pre>

修改上传／下载限制。

<pre>
[fileserver]
# Set maximum upload file size to 200M.
max_upload_size=200

# Set maximum download directory size to 200M.
max_download_dir_size=200
</pre>

'''Note''': 重启Seafile和Seahub后生效。

<pre>
./seahub.sh restart
./seafile.sh restart
</pre>

## Seahub 配置 (seahub_settings.py)

### Seahub 邮件发送

重置密码，发送外链，消息通知等几个服务需要邮件发送。在seahub_settings.py 中写入以下配置：

<pre>
EMAIL_USE_TLS = False
EMAIL_HOST = 'smtp.domain.com'        # smpt server
EMAIL_HOST_USER = 'username@domain.com'    # username
EMAIL_HOST_PASSWORD = 'password'    # password
EMAIL_PORT = '25'
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
</pre>

如果使用gmail来发送邮件，使用以下的配置：

<pre>
EMAIL_USE_TLS = True
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = 'username@gmail.com'
EMAIL_HOST_PASSWORD = 'password'
EMAIL_PORT = 587
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
</pre>

'''Note''': 如果按照以上配置仍旧无法配成功，请查看<code>/tmp/seahub.log</code>，里面会有详细的错误信息。

### 定制 Seahub Logo

1. 添加你的logo文件到 <code>seahub/media/img/</code>

2. 在 <code>seahub_settings.py</code> 覆盖 <code>LOGO_PATH</code> 配置

<pre>
LOGO_PATH = img/<your-logo-file-name>
</pre>

3. 在 <code>seahub_settings.py</code> 覆盖 <code>LOGO_URL</code> 配置

<pre>
LOGO_URL = 'http://your-seafile.com'
</pre>

### Seahub 参数配置

Seahub 的配置可以在 seahub_settings.py 里覆盖。以下是几个可配置的参数。

<pre>

# 必须改成你的网址，该参数用在邮件发送服务里用户可点击的网址
SITE_BASE = 'http://gonggeng.org/'

# 必须改成你的网站名称，该参数用在邮件发送服务里的署名
SITE_NAME = 'gonggeng'

# 修改 Seahub 网站的标题，可选参数
SITE_TITLE = 'Seafile'

# 如果不是部署在根路径下，需要将该参数修改成相应的路径，可选参数
# 例如：将seahub部署到http://example.com/seahub/下，则需要将该参数修改成 '/seahub/'
SITE_ROOT = '/'

# 网站管理员可以重置用户的密码，重置后的初始密码为 123456，可选参数
INIT_PASSWD = '123456'

# 在线浏览pdf文件时是否使用 pdf.js。 默认为 ｀True`。
# NOTE: since version 1.4.
USE_PDFJS = True

# 开启或禁用网站上的新用户注册功能。默认为 `False｀。
# NOTE: since version 1.4.
ENABLE_SIGNUP = False

# 系统管理员添加用户时，是否向该用户发送通知邮件。默认为 `True`。
# NOTE: since version 1.4.
SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

# 系统管理员重置用户密码时，是否向该用户发送通知邮件。默认为 `True`。
# NOTE: since version 1.4.
SEND_EMAIL_ON_RESETTING_USER_PASSWD = True

</pre>

'''Note''': 重启Seahub后生效。

<pre>
./seahub.sh restart
</pre>
