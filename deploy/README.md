# Deploying Seafile under Linux

Here we describe how to deploy Seafile from prebuild binary packages.

### Deploy Seafile in Home/Personal Environment

* [Deploying Seafile with SQLite](using_sqlite.md)

### Deploy Seafile in Production/Enterprise Environment

In production environment we recommend using MySQL as the database and config Seafile web behing Nginx or Apache. For those who are not familiar with Nginx and Apache. We recommend Nginx, since it is easier to config than Apache.

Basic:

* [Deploying Seafile with MySQL](using_mysql.md)
* [Config Seahub with Nginx](deploy_with_nginx.md)
* [Enabling Https with Nginx](https_with_nginx.md)
* [Config Seahub with Apache](deploy_with_apache.md)
* [Enabling Https with Apache](https_with_apache.md)

Advanced:

* [Configure Seafile to use LDAP](using_ldap.md)
* [Start Seafile at System Bootup](start_Seafile_at_system_bootup.md)
* [Firewall settings](using_firewall.md)
* [Logrotate](using_logrotate.md)
* [Add Memcached](add_memcached.md)

Other Deployment Issues

* [Deploy Seafile behind NAT](deploy_Seafile_behind_NAT.md)
* [Deploy Seahub at Non-root domain](deploy_Seahub_at_Non-root_domain.md)
* [Migrate From SQLite to MySQL](migrate_from_sqlite_to_mysql.md)

Check [configuration options](../config/README.md) for server config options like enabling user registration.

**Read here** if you have troubles setting up Seafile server

1. Read [Seafile Server Components Overview](../overview/components.md) to understand how Seafile server works. This will save you a lot of time.
2. [Common Problems for Setting up Server](common_problems_for_setting_up_server.md)
3. Use our google group forum or IRC to get help.

## Upgrade Seafile Server

* [Upgrade Seafile server](upgrade.md)

## For those that want to package Seafile server

If you want to package seafile yourself, (e.g. for your favorite Linux distribution), you should always use the correspondent tags:

* When we release a new version of seafile client, say 3.0.1, we will add tags `v3.0.1` to ccnet, seafile and seafile-client.
* Likewise, when we release a new version of seafile server, say 3.0.1, we will add tags `v3.0.1-server` to ccnet, seafile and seahub.
* For libsearpc, we always use tag `v3.0-latest`.

**Note**: The version numbers of each project has nothing to do with the tag name.
