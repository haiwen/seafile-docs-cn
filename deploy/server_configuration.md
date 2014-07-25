# Server Configuration and Customization

This manual explains how to change various config options for Seafile server.

There are three config files in the community edition:

- [ccnet/ccnet.conf](ccnet-conf.md): contains the network settings
- [seafile-data/seafile.conf](seafile-conf.md): contains settings for seafile daemon and FileServer.
- [seahub_settings.py](seahub_settings_py.md): contains settings for Seahub

There is one additional config file in the pro edition:

- `pro-data/seafevents.conf`: contains settings for search and documents preview




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

## Seafile fileserver configuration (seafile.conf)

The configuration of seafile fileserver is in the <code>[fileserver]</code> section of the file <code>seafile-data/seafile.conf</code>

<pre>
[fileserver]
# tcp port for fileserver
port = 8082
</pre>

Change upload/download settings.

<pre>
[fileserver]
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

## Seahub Configurations (seahub_settings.py)

#### Sending Email Notifications on Seahub

A few features work better if it can send email notifications, such as notifying users about new messages.
If you want to setup email notifications, please add the following lines to seahub_settings.py (and set your email server).

<pre>
EMAIL_USE_TLS = False
EMAIL_HOST = 'smtp.domain.com'        # smpt server
EMAIL_HOST_USER = 'username@domain.com'    # username and domain
EMAIL_HOST_PASSWORD = 'password'    # password
EMAIL_PORT = '25'
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
</pre>

If you are using Gmail as email server, use following lines:

<pre>
EMAIL_USE_TLS = True
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = 'username@gmail.com'
EMAIL_HOST_PASSWORD = 'password'
EMAIL_PORT = 587
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
</pre>

**Note**: If your Email service still can not work, you may checkout the log file <code>logs/seahub.log</code> to see what may cause the problem. For complete email notification list, please refer to [Email notification list](customize_email_notifications.md).

**Note2**: If you want to use the Email service without authentication leaf <code>EMAIL_HOST_USER</code> and <code>EMAIL_HOST_PASSWORD</code> **blank** (<code>''</code>). (But notice that the emails then will be sent without a <code>From:</code> address.)

#### Cache

Seahub caches items(avatars, profiles, etc) on file system by default(/tmp/seahub_cache/). You can replace with Memcached (you have to install python-memcache first).

<pre>
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
	'LOCATION': '127.0.0.1:11211',
    }
}
</pre>

#### Seahub Settings

You may change seahub website's settings by adding variables in `seahub_settings.py`.

<pre>

# Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'UTC'

# Set this to seahub website's URL. This URL is contained in email notifications.
SITE_BASE = 'http://www.example.com/'

# Set this to your website's name. This is contained in email notifications.
SITE_NAME = 'example.com'

# Set seahub website's title
SITE_TITLE = 'Seafile'

# If you don't want to run seahub website on your site's root path, set this option to your preferred path.
# e.g. setting it to '/seahub/' would run seahub on http://example.com/seahub/.
SITE_ROOT = '/'

# Whether to use pdf.js to view pdf files online. Default is `True`,  you can turn it off.
# NOTE: since version 1.4.
USE_PDFJS = True

# Enalbe or disalbe registration on web. Default is `False`.
# NOTE: since version 1.4.
ENABLE_SIGNUP = False

# Activate or deactivate user when registration complete. Default is `True`.
# If set to `False`, new users need to be activated by admin in admin panel.
# NOTE: since version 1.8
ACTIVATE_AFTER_REGISTRATION = False

# Whether to send email when a system admin adding a new member. Default is `True`.
# NOTE: since version 1.4.
SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True

 # Whether to send email when a system admin resetting a user's password. Default is `True`.
# NOTE: since version 1.4.
SEND_EMAIL_ON_RESETTING_USER_PASSWD = True

# Hide `Organization` tab.
# If you want your private seafile behave exactly like https://cloud.seafile.com/, you can set this flag.
CLOUD_MODE = True

# Online preview maximum file size, defaults to 30M.
FILE_PREVIEW_MAX_SIZE = 30 * 1024 * 1024

# Age of cookie, in seconds (default: 2 weeks).
SESSION_COOKIE_AGE = 60 * 60 * 24 * 7 * 2

# Whether to save the session data on every request.
SESSION_SAVE_EVERY_REQUEST = False

# Whether a user's session cookie expires when the Web browser is closed.
SESSION_EXPIRE_AT_BROWSER_CLOSE = False

# Using server side crypto by default, otherwise, let user choose crypto method.
FORCE_SERVER_CRYPTO = True

</pre>

**Note**:

* You need to restart seahub so that your changes take effect.
* If your changes don't take effect, You may need to delete 'seahub_setting.pyc'. (A cache file)

<pre>
./seahub.sh restart
</pre>
