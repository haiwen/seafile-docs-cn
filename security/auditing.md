# Access log and auditing

In pro edition, Seafile offers four auditing logs in system admin panel:

* Login log
* File access log
* File update log
* Permission change log

The logging feature is turned off by default. See [config options for pro edition](../deploy_pro/configurable_options.md) for how to turn it on.

## file access log

Access log (under directory logs/stats-logs) records the following information

* file download via Web
* file download via API (including mobile clients and cloud file browser)
* file sync via desktop clients

The format is:

    user, operation type, ip/device, date, library, path. 

## file update log

The format is:

    user, date, library, path, detail

## permission change log

The format is:

    user, grant to, operation, permission, library, folder, date
