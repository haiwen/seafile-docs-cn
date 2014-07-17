# Upgrading Seafile Professional Server

This page is for users who use the pre-compiled seafile server package. 

- If you [build seafile server from source](https://github.com/haiwen/seafile/wiki/Build-and-deploy-seafile-server-from-source), please read the **Upgrading Seafile Server** section on that page, instead of this one.

- After upgrading, you may need to clean [seahub cache](../deploy/add_memcached.md) if it doesn't behave as expect.

## Major Continuous Upgrade (like from 1.2.x to 1.3.y)

Continuous upgrade means to upgrade from one version of Seafile server to the next version.
For example, upgrading from 1.2.0 to 1.3.0 (or upgrading from 1.2.0 to 1.3.1) is a continuous upgrade.

After downloading and extracting the new version, you should have a directory layout similar to this:

<pre>
haiwen
   -- seafile-server-1.2.0
   -- seafile-server-1.3.0
   -- ccnet
   -- seafile-data
</pre>


Now upgrade to version 1.3.0.

1. Shutdown Seafile server if it's running

   ```sh
   cd haiwen/seafile-server-1.2.0
   ./seahub.sh stop
   ./seafile.sh stop
   ```
2. Run the upgrade script in seafile-server-1.3.0 directory.

   ```sh
   cd haiwen/seafile-server-1.3.0
   upgrade/upgrade_1.2_1.3_server.sh
   ```
3. Start the new server version as for any upgrade 

   ```sh
   cd haiwen/seafile-server-1.3.0/
   ./seafile.sh start
   ./seahub.sh start
   ```

## Noncontinuous Upgrade (like from 1.1 to 1.3)

You may also upgrade a few versions at once, e.g. from 1.1.0 to 1.3.0.
The procedure is:

1. upgrade from 1.1.0 to 1.2.0;
2. upgrade from 1.2.0 to 1.3.0.

Just run the upgrade scripts in sequence. (You don't need to download server package 1.2.0)

## Minor upgrade (like from 1.5.0 to 1.5.1)

Minor upgrade is like an upgrade from 1.5.0 to 1.5.1. 

Here is our dir strutcutre

<pre>
haiwen
   -- seafile-server-1.5.0
   -- seafile-server-1.5.1
   -- ccnet
   -- seafile-data
</pre>

1. Stop the current server first as for any upgrade

    ```sh
    seafile-server-1.5.0/seahub.sh stop
    seafile-server-1.5.0/seafile.sh stop
    ```

1. For this type of upgrade, you only need to update the avatar link. We provide a script for you, just run it:

    ```sh
    cd seafile-server-1.5.1
    upgrade/minor-upgrade.sh
    ```

1. Start the new server version as for any upgrade 

    ```sh
    cd ..
    seafile-server-1.5.1/seafile.sh start
    seafile-server-1.5.1/seahub.sh start
    ```

1. If the new version works file, the old version can be removed

    ```sh
    rm -rf seafile-server-1.5.0
    ```
