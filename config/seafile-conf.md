# Seafile.conf settings

## Storage Quota Setting (seafile.conf)

You may set a default quota (e.g. 2GB) for all users. To do this, just add the following lines to `seafile-data/seafile.conf` file

<pre>
[quota]
# default user quota in GB, integer only
default = 2
</pre>

This setting applies to all users. If you want to set quota for a specific user, you may log in to seahub website as administrator, then set it in "System Admin" page.

## Default history length limit (seafile.conf)

If you don't want to keep all file revision history, you may set a default history length limit for all libraries.

<pre>
[history]
keep_days = days of history to keep
</pre>

## Seafile httpserver configuration (seafile.conf)

The configuration of seafile httpserver is in the <code>[httpserver]</code> section of the file <code>seafile-data/seafile.conf</code>

<pre>
[httpserver]
# tcp port for httpserver
port = 8082
</pre>

Change upload/download settings.

<pre>
[httpserver]
# Set maximum upload file size to 200M.
max_upload_size=200

# Set maximum download directory size to 200M.
max_download_dir_size=200
</pre>

**Note**: You need to restart seafile and seahub so that your changes take effect.
<pre>
./seahub.sh restart
./seafile.sh restart
</pre>
