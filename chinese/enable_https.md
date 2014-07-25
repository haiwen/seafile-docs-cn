# Seafile
## Seahub 启用Https

SSL数字证书需要向相应机构购买，这里使用免费的自认证证书。

1. 生成SSL数字认证

    openssl genrsa -out privkey.pem 2048

    openssl req -new -x509 -key privkey.pem -out cacert.pem -days 1095

2. 启用Nginx的SSL模块（可选）

如果Nginx没有启用SSL模块，则需要重新编译。命令如下：

    ./configure --with-http_stub_status_module --with-http_ssl_module

    make && make install

3. 修改Nginx配置

    server
    {
    listen 443;
    ssl on;
    ssl_certificate /etc/ssl/cacert.pem;	# 需要改成cacert.pem的路径
    ssl_certificate_key /etc/ssl/privkey.pem;	# 需要改成privkey.pem的路径
    server_name www.yourdoamin.com;
    index index.html index.htm index.php;
    root /home/wwwroot/yourdomain;
    ......
    ......
    }


4. 重载Nginx配置

    nginx -s reload

5. 测试Https

登陆到 https://www.yourdomain.com, 如果看到浏览器的关于证书错误的警告，则表示配置成功。

## Seafile fileserver 启用Https

'''Note:''' 仅对 seafile server 1.4 或之后版本生效。

Seafile fileserver的配置在文件<code>seafile-data/seafile.conf</code>里，加入以下几行到<code>seafile.conf</code>：
<pre>
[fileserver]
port=8082
https=true
pemfile=/path/to/pemfile
privkey=/path/to/privkey
</pre>

8082是默认端口，你可以使用任何有效的端口。

修改完<code>seafile.conf</code>后，需要通过<code>./seafile.sh restart</code>重启Seafile。之后在浏览器里输入<code>https://www.yourdomain.com:8082</code>，出现空白页面，则表示配置成功。

'''Note:''' 如果你的密钥文件已加密，请先解密。

## 修改配置使Https生效

#### ccnet conf

你需要修改 <code>ccnet/ccnet.conf</code> 中的"SERVICE_URL"：
<pre>
SERVICE_URL = https://your.server.domain
</pre>
