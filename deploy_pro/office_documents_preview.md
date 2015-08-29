Seafile Professional server supports previewing office/pdf documents online, to use it you need to follow the steps described on this page.

### Install Libreoffice/UNO ###

Libreoffice 4.1+ and Python-uno library are needed to enable office files online preview.

On Ubuntu/Debian:
```
sudo apt-get install libreoffice libreoffice-script-provider-python
```
> For older version of Ubuntu: `sudo apt-get install libreoffice python-uno`

On Centos/RHEL:
```
sudo yum install libreoffice libreoffice-headless libreoffice-pyuno
```

For other Linux distro: [Installation of LibreOffice on Linux](http://www.libreoffice.org/get-help/installation/linux/)

Also, you may need to install fonts for your language, especially for Asians, otherwise the  office/pdf document may not display correctly.

For example, Chinese users may wish to install the WenQuanYi series of truetype fonts:

```
# For ubuntu/debian
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
```

### Enable Office Preview

1. Open file `pro-data/seafevents.conf`, in the `OFFICE CONVERTER` section:
```conf
[OFFICE CONVERTER]
enabled = true
```
2. After modifying and saving `seafevents.conf`, restart seafile server by `./seafile.sh restart`
3. Open a doc/ppt/xls/pdf file on seahub, you should be about the previewing it in your browser.

### Other Configurable Options

Here are full list of options you can fine tune:

```conf
[OFFICE CONVERTER]

## must be "true" to enable office/pdf file online preview
enabled = true

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

## <a id="wiki-doc-preview"></a>FAQ about Office/PDF document preview ##

- Document preview doesn't work, where to find more information?

    You can check the log at logs/seafevents.log


- How can I change max size and max pages of documents that can be previewed online ?

 1. Locate the `OFFICE CONVERTER` section in `/data/haiwen/pro-data/seafevents.conf`.
 2. Append following lines to the section
```
# the max size of documents to allow to be previewed online, in MB. Default is 2 MB
max-size = 2
# how many pages are allowed to be previewed online. Default is 50 pages
max-pages = 50
```

Then, restart seafile server
```
cd /data/haiwen/seafile-server-latest/
./seafile.sh restart
./seahub.sh restart
```

- Document preview doesn't work on my Ubuntu/Debian server, what can I do?

Current office online preview works with libreoffice 4.0-4.2. If the version of libreoffice installed by `apt-get` is too old or too new, you can solve this by:

- Remove the installed libreoffice:
```
sudo apt-get remove libreoffice* python-uno python3-uno
```
- Download libreoffice packages from [libreoffice official site](http://sourceforge.net/projects/libreoffice.mirror/files/LibreOffice%204.1.6/)

- Install the downloaded pacakges:
```
tar xf LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
cd LibreOffice_4.1.6.2_Linux_x86-64_deb
cd DEBS
sudo dpkg -i *.deb
```

- Restart your seafile server and try again. It should work now.
```
./seafile.sh restart
```
