# Changelog
## 3.0

### 3.0.7

* Add support for logrotate
* [fix] Fix script for migrating from community edition

### 3.0.6

* Fix seahub failing to start problem when Ceph backend is used

### 3.0.5

* Add option to enable highlight search keyword in the file view
* [fix] Fix "Save to My Library" in file sharing
* [fix] Fix API for renaming files containing non-ASCII characters from mobile clients

### 3.0.4

* Add support for MariaDB Cluster

### 3.0.3

Web

* Show a notice when one tries to reset/change the password of a LDAP user
* Improve the initial size of pdf/office documents online preview
* Handle languages more gracefully in search
* Highlight the keywords in the search results
* [Fix] Fixed a web page display problem for French language

Platform

* Improve the speed when saving objects to disks
* Show error messages when seahub.sh script failed to start

### 3.0.2

* Added Ceph storage backend support
* Use random ID as avatar file name instead of the file name uploaded by the user

### 3.0.1

* [fix] Fix an UI bug in selecting multiple contacts in sending message
* Library browser page: Loading contacts asynchronously to improve initial loading speed

### 3.0.0

Web

* Redesigned UI
* [admin] Add login log
* [admin] Add share link traffic statistics
* [fix] Handle loading avatar exceptions to avoid 500 error
* Fixed a few api errors
* Improve page loading speed
* [fix] Fix UI problem when selecting contacts in personal message send form
* [fix] Add nickname check and escape nickname to prevent XSS attack
* [fix] Check validity of library name (only allow a valid directory name).

Platform

* Separate the storage of libraries
* Record files' last modification time directly
* Keep file timestamp during syncing
* Allow changing password of an encrypted library
* Allow config httpserver bind address
* Improved device (desktop and mobile clients) management

Misc

* [fix] Fix API for uploading files from iOS in an encrypted library.
* [fix] Fix API for getting groups messages containing multiple file attachments
* [fix] Fix bug in HttpServer when file block is missing
* [fix] Fix login error for some kind of Android


## 2.2

### 2.2.1

* Add more checking for the validity of users' Email
* Use random salt and PBKDF2 algorithm to store users' password.

## 2.1

### 2.1.5

* Add correct mime types for mp4 files when downloading
* [fix] [Important] set correct file mode bit after uploading a file from web.
* Show meaningful message instead of "auto merged by system" for file merges
* Improve file history calculation for files which were renamed

WebDAV

* Return last modified time of files

### 2.1.4-1

* [fix] fixed the `pro.py search --clear` command
* [fix] fixed full text search for office/pdf files

### 2.1.4

* Improved Microsoft Excel files online preview
* [fix] Fixed file share link download issue on some browsers.
* [wiki] Enable create index for wiki.
* Hide email address in avatar.
* Show "create library" button on Organization page.
* [fix] Further improve markdown filter to avoid XSS attack.

### 2.1.3

* Fixed a problem of Seafile WebDAV server

### 2.1.2 

* Fixed a problem of requiring python boto library even if it's not needed.

### 2.1.1

Platform

* Added FUSE support, currently read-only
* Added WebDAV support
* A default library would be created for new users on first login to seahub
* Upgrade scripts support MySQL databases now


Web

* Redesigned Web UI
* Redesigned notification module
* Uploadable share links
* [login] Added captcha to prevent brute force attack
* [login] Allow the user to choose the expiration of the session when login
* [login] Change default session expiration age to 1 day
* [fix] Fixed a bug of "trembling" when scrolling file lists
* [sub-library] User can choose whether to enable sub-library
* Improved error messages when upload fails
* Set default browser file upload size limit to unlimited


Web for Admin

* Improved admin UI
* More flexible customization options
* Support specify the width of height of custom LOGO
* Online help is now bundled within Seahub



## 2.0


### 2.0.5

* Support S3-compatible storage backends like Swift
* Support use existing elasticsearch server

### 2.0.4

* [fix] set the utf8 charset when connecting to database
* Use users from both database and LDAP
* [admin] List database and LDAP users in sysadmin

### 2.0.3 ###

* [fix] Speed up file syncing when there are lots of small files

### 2.0.1 ###

* [fix] Elasticsearch now would not be started if search is not enabled
* [fix] Fix CIFS support.
* [fix] Support special characters like '@' in MySQL password
* [fix] Fix create library from desktop client when deploy Seafile with Apache.
* [fix] Fix sql syntax error in ccnet.log, issue #400 (https://github.com/haiwen/seafile/issues/400).
* [fix] Return organization libraries to the client.
* Update French, German and Portuguese (Brazil) languages.

### 2.0.0 ###

Platform

* New crypto scheme for encrypted libraries
* A fsck utility for checking data integrity

Web

* Change owner of a library/group
* Move/delete/copy multiple files
* Automatically save draft during online editing  
* Add "clear format" to .seaf file online editing
* Support user delete its own account
* Hide Wiki module by default
* Remove the concept of sub-library

Web for Admin

* Change owner of a library
* Search user/library

API

* Add list/add/delete user API


## 1.8

### 1.8.3

- Improve seahub.sh
- Improve license checking

### 1.8.2

- fixed 'cannot enter space' bug for .seaf file online edit
- add paginating for repo files list
- fixed a bug for empty repo

### 1.8.1

- Remove redundant log messages


### 1.8.0

Web

* Improve online file browsing and uploading
    - Redesigned interface
    - Use ajax for file operations
    - Support selecting of multiple files in uploading
    - Support drag/drop in uploading
* Improve file syncing and sharing
    - Syncing and sharing a sub-directory of an existing library.
    - Directly sharing files between two users (instead of generating public links)
    - User can save shared files to one's own library
* [wiki] Add frame and max-width to images
* Use 127.0.0.1 to read files (markdown, txt, pdf) in file preview
* [bugfix] Fix pagination in library snapshot page
* Set the max length of message reply from 128 characters to 2000 characters. 

API

* Add creating/deleting library API

Platform

* Improve HTTPS support, now HTTPS reverse proxy is the recommend way.
* Add LDAP filter and multiple DN
* Case insensitive login
* Move log files to a single directory
* [security] Add salt when saving user's password
* [bugfix] Fix a bug in handling client connection
* Add a script to automate setup seafile with MySQL



## 1.7

### 1.7.0.4

- Fixed a bug in file activities module

### 1.7.0

- First release of Seafile Professional Server
