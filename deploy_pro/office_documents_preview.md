Seafile 专业版服务器支持在线预览 office 文件，配置方法如下。

### 安装 Libreoffice/UNO ###

Office 预览依赖于 Libreoffice 4.1+ 和 Python-uno 库。

Ubuntu/Debian:
```
sudo apt-get install libreoffice libreoffice-script-provider-python poppler-utils
```
> For older version of Ubuntu: `sudo apt-get install libreoffice python-uno`

Centos/RHEL:
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno poppler-utils
```

其他 Linux 发行版可以参考: [Installation of LibreOffice on Linux](http://www.libreoffice.org/get-help/installation/linux/)

你还需要安装字体文件:

Ubuntu/Debian:
```
# For ubuntu/debian
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```

CentOS:
```
# For CentOS
sudo yum install wqy-microhei-fonts wqy-zenhei-fonts wqy-unibit-fonts -y
```

### 开启配置项

1. 打开 `conf/seafevents.conf`, 添加:

```conf
[OFFICE CONVERTER]
enabled = true
```
2. 保存 `seafevents.conf` 后，重启 Seafile 服务 `./seafile.sh restart`

### 其他配置选项


```conf
[OFFICE CONVERTER]

## 并发运行 libreoffice 的进程数
workers = 1

## 转换后的 office/pdf 文件的缓存路径。 默认是 /tmp/.
outputdir = /tmp/

```

## <a id="wiki-doc-preview"></a>FAQ ##

#### Office 预览不能工作，日志文件在哪?

你可以查看 logs/seafevents.log

Office 预览不能工作的一个可能原因是你的机器上的 libreoffice 版本太低，可以用以下方法修复

删除安装的 libreoffice:
```
sudo apt-get remove libreoffice* python-uno python3-uno
```

从官网下载最新版 [libreoffice official site](http://sourceforge.net/projects/libreoffice.mirror/files/LibreOffice%204.1.6/)，并安装

```
tar xf LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
cd LibreOffice_4.1.6.2_Linux_x86-64_deb
cd DEBS
sudo dpkg -i *.deb
```

重启 Seafile 服务
```
./seafile.sh restart
```
