# Seafile FSCK

On the server side, Seafile stores the files in the libraries in an internal format. Seafile has its own representation of directories and files (similar to Git).

With default installation, these internal objects are stored in the server's file system directly (such as Ext4, NTFS). But most file systems don't assure the integrity of file contents after a hard shutdown or system crash. So if new Seafile internal objects are being written when the system crashes, they can be corrupt after the system reboots. This will make part of the corresponding library not accessible.

Note: If you store the seafile-data directory in a battery-backed NAS (like EMC or NetApp), or use S3 backend available in the Pro edition, the internal objects won't be corrupt.

Starting from version 2.0, Seafile server comes with a seaf-fsck tool to help you recover from this corruption (similar to git-fsck tool). This tool does two things:

1. Check Seafile internal objects integrity, and delete corrupt objects;
2. Reset any affected library to its last consistent and usable state.

The seaf-fsck tool accepts the following arguments:

```
seaf-fsck [-c config_dir] [-d seafile_dir] [repo_id_1 [repo_id_2 ...]]
Additional options:
-D, --dry-run: check fs objects and blocks, but don't remove them.
-s, --strict: check whether fs object id consistent with content.
```

Supposed you follow the standard installation and directory layout, and your seafile installation directory is `/data/haiwen`, you should run the command as

```
cd /data/haiwen/seafile-server-{version}/seafile
export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
./bin/seaf-fsck -c ../../ccnet -d ../../seafile-data
```

This will check and recover all libraries on the server.

If you know exactly which library is corrupt, you can also specify the library's id in the command line. A library's id can be obtained by navigating into the library on seahub. In the browser's address bar, you should see something like: `https://seafile.example.com/repo/601c4f2f-5209-47a0-b939-1f8c7fae9ff2`. `601c4f2f-5209-47a0-b939-1f8c7fae9ff2` is the library id.

After the recovery, a few latest changes to the files may be lost, but you can access the full library now. Also note that some clients synced with the library can fail to sync. If this happens, you can unsync the library on the client and resync with the library's folder.
