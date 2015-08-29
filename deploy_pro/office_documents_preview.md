Seafile 专业版服务器支持在线预览 office 文件，配置方法如下。

### 安装 Libreoffice/UNO ###

Office 预览依赖于 Libreoffice 4.1+ 和 Python-uno 库。

Ubuntu/Debian:
```
sudo apt-get install libreoffice libreoffice-script-provider-python
```
> For older version of Ubuntu: `sudo apt-get install libreoffice python-uno`

Centos/RHEL:
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno
```

其他 Linux 发行版可以参考: [Installation of LibreOffice on Linux](http://www.libreoffice.org/get-help/installation/linux/)

你还需要安装字体文件:

```
# For ubuntu/debian
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```

### 开启配置项

1. 打开 `pro-data/seafevents.conf`, 添加:
```conf
[OFFICE CONVERTER]
enabled = true
```
2. 保存后 `seafevents.conf` 重启 Seafile 服务 `./seafile.sh restart`

### 其他配置选项


```conf
[OFFICE CONVERTER]

## How many libreoffice worker processes to run concurrenlty
workers = 1

## where to store the converted office/pdf files. Deafult is /tmp/.
outputdir = /tmp/

## how many pages are allowed to be previewed online. Default is 50 pages
max-pages = 50

## the max size of documents to allow to be previewed online, in MB. Default is 2 MB
## Preview a large file (for example >30M) online will freeze the browser.
max-size = 2

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
