# FAQ
## <a id="wiki-search-faq"></a>FAQ about Search ##

- However I tried, files in an encrypted library aren't listed in the search results 

  This is because the server can't index encrypted files, since, they are encrypted.

- I switched to Professional Server from Community Server, but whatever I search, I get no results

  The search index is updated every 10 minutes by default. So before the first index update is performed, you get nothing no matter what you search.

  To be able to search immediately,

  - Make sure you have started seafile server
  - Update the search index manually:
  ```
  cd haiwen/seafile-pro-server-1.7.0
  ./pro/pro.py search --update
  ```

  If you have lots of files, this process may take quite a while.

- I want to enable full text search for office/pdf documents, so I set `index_office_pdf` to `true` in the configuration file, but it doesn't work.

  In this case, you need to:
  1. Edit the value of `index_office_pdf` option in `/data/haiwen/pro-data/seafevents.conf` to `true`
  2. Restart seafile server
  ```
  cd /data/haiwen/seafile-pro-server-1.7.0/
  ./seafile.sh restart
  ```
  3. Delete the existing search index
  ```
  ./pro/pro.py search --clear
  ```
  4. Create and update the search index again
  ```
  ./pro/pro.py search --update
  ```

## <a id="wiki-doc-preview"></a>FAQ about Office/PDF document preview ##

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
cd /data/haiwen/seafile-pro-server-1.7.0/
./seafile.sh restart
./seahub.sh restart
```

- Document preview doesn't work on my Ubuntu 14.04 server, what can I do?

Current office online preview works with libreoffice 4.1 or lower versions. The default version of libreoffice on ubuntu 14.04 server is 4.2. To solve this:

Remove the installed libreoffice:
```
sudo apt-get remove libreoffice* python3-uno
```
Download libreoffice packages from libreoffice official site:
```
wget http://ftp.jaist.ac.jp/pub/tdf/libreoffice/stable/4.1.6/deb/x86_64/LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
```
Install the downloaded pacakges:
```
tar xf LibreOffice_4.1.6_Linux_x86-64_deb.tar.gz
cd LibreOffice_4.1.6.2_Linux_x86-64_deb
cd DEBS
sudo dpkg -i *.deb
```

Restart your seafile server and try again. It should work now.
```
./seafile.sh restart
```
