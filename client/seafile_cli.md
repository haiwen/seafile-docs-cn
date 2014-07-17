# Seafile CLI

init
----
Initialize config file

usage: seaf-cli -c <config-dir> -o init

start
-----
Start seafile-applet to run a seafile client

usage: seaf-cli -c <config-dir> -o start

start-ccnet
-----------
Start ccnet daemon

usage: seaf-cli -c <config-dir> -o start-ccnet

start-seafile
-------------
Start seafile daemon

usage: seaf-cli -c <config-dir> [-w <worktree>] -o start-seafile

clone
-----
Clone a repo from seafile server

A repo id and a url need to be give because this program need to use seafile web
API v2 to fetch repo information.

usage: seaf-cli -c <config-dir> -r <repo-id> -u <url> [-w <worktree>] -o clone

sync
----
Try to synchronize a repo

usage: seaf-cli -c <config-dir> -r <repo-id> -o clone

remove
------
Try to desynchronize a repo

usage: seaf-cli -c <config-dir> -r <repo-id> -o remove

## Usage

Subcommands:

    init:           create config files for seafile client
    start:          start and run seafile client as daemon
    stop:           stop seafile client
    list:           list local liraries
    status:         show syncing status
    download:       download a library from seafile server
    sync:           synchronize an existing folder with a library in
                        seafile server
    desync:         desynchronize a library with seafile server


##More details

Seafile client stores all its configure information in a config dir. The default location is `~/.ccnet`. All the commands below accept an option `-c <config-dir>`.

init
----
Initialize seafile client. This command initializes the config dir. It also creates sub-directories `seafile-data` and `seafile` under `parent-dir`. `seafile-data` is used to store internal data, while `seafile` is used as the default location put downloaded libraries.

    seaf-cli init [-c <config-dir>] -d <parent-dir>

start
-----
Start seafile client. This command start `ccnet` and `seaf-daemon`, `ccnet` is the network part of seafile client, `seaf-daemon` manages the files.

    seaf-cli start [-c <config-dir>]

stop
----
Stop seafile client.

    seaf-cli stop [-c <config-dir>]


Download
--------
Download a library from seafile server

    seaf-cli download -l <library-id> -s <seahub-server-url> -d <parent-directory> -u <username> [-p <password>]


sync
----
Synchronize a library with an existing folder.

    seaf-cli sync -l <library-id> -s <seahub-server-url> -d <existing-folder> -u <username> [-p <password>]

desync
------
Desynchronize a library from seafile server

    seaf-cli desync -d <existing-folder>
