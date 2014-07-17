# Configure Seafile to use LDAP
The current code of seahub assumes that user name to be email address, so it's not possible to log in with UNIX user names or Windows Domain user names now. The support may be added later.

Seafile will find a user both from database and LDAP. LDAP will be tried first. Note that the Seafile admin  account created during setup is always stored in sqlite/mysql database.

## Connect to LDAP/AD from Linux

To use LDAP to authenticate user, please add the following lines to ccnet.conf

    [LDAP]
    # LDAP URL for the host, ldap://, ldaps:// and ldapi:// are supported
    # To use TLS, you should configure the LDAP server to listen on LDAPS
    # port and specify ldaps:// here.
    HOST = ldap://ldap.example.com
    # base DN from where all the users can be reached.
    BASE = ou=users,dc=example,dc=com
    # LDAP admin user DN to bind to. If not set, will use anonymous login.
    USER_DN = cn=seafileadmin,dc=example,dc=com
    # Password for the admin user DN
    PASSWORD = secret
    # The attribute to be used as user login id.
    # By default it's the 'mail' attribute.
    LOGIN_ATTR = mail

Example config for LDAP:

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

Example config for Active Directory:

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = mail

If you're using Active Directory but don't have email address for the users, you can use the following config:

    [LDAP]
    HOST = ldap://192.168.1.123/
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

The `userPrincipalName` is an user attribute provided by AD. It's usually of the form `username@domain-name`, where `username` is Windows user login name. The the user can log in to seahub with `username@domain-name`, such as `poweruser@example.com`. Note that such login name is not actually an email address. So sending emails from seahub won't work with this setting.

## Connect to LDAP/AD from Windows server

The config syntax on Windows is slightly different from Linux. **You should not add ldap:// prefix to the HOST field.**

To use LDAP to authenticate user, please add the following lines to ccnet.conf

    [LDAP]
    # You can optionally specify the port of LDAP/AD server in the HOST field
    HOST = ldap.example.com[:port]
    # Default 'false'. Set to true if you want Seafile to communicate with the LDAP server via SSL connection.
    USE_SSL = true | false
    # base DN from where all the users can be reached.
    BASE = ou=users,dc=example,dc=com
    # LDAP admin user DN to bind to. If not set, will use anonymous login.
    USER_DN = cn=seafileadmin,dc=example,dc=com
    # Password for the admin user DN
    PASSWORD = secret
    # The attribute to be used as user login id.
    # By default it's the 'mail' attribute.
    LOGIN_ATTR = mail

Example config for LDAP:

    [LDAP]
    HOST = 192.168.1.123
    BASE = ou=users,dc=example,dc=com
    USER_DN = cn=admin,dc=example,dc=com
    PASSWORD = secret
    LOGIN_ATTR = mail

Example config for Active Directory:

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = mail

If you're using Active Directory but don't have email address for the users, you can use the following config:

    [LDAP]
    HOST = 192.168.1.123
    BASE = cn=users,dc=example,dc=com
    USER_DN = cn=admin,cn=users,dc=example,dc=com # or use admin@example.local etc
    PASSWORD = secret
    LOGIN_ATTR = userPrincipalName

The `userPrincipalName` is an user attribute provided by AD. It's usually of the form `username@domain-name`, where `username` is Windows user login name. The the user can log in to seahub with `username@domain-name`, such as `poweruser@example.com`. Note that such login name is not actually an email address. So sending emails notifications from Seahub won't work with this setting.

## Multiple base DN/Additional search filter

Multiple base DN is useful when your company has more than one OUs to use Seafile. You can specify a list of base DN in the "BASE" config. The DNs are separated by ";", e.g. `cn=developers,dc=example,dc=com;cn=marketing,dc=example,dc=com`

Search filter is very useful when you have a large organization but only a portion of people want to use Seafile. The filter can be given by setting "FILTER" config. For example, add the following line to LDAP config:

```
FILTER = memberOf=CN=group,CN=developers,DC=example,DC=com
```

Note that the cases in the above example is significant. The `memberOf` attribute is only available in Active Directory.

Here is another example:

```
FILTER = &(!(UserAccountControl:1.2.840.113556.1.4.803:=2))
```

## Known Issues

### ldaps (LDAP over SSL) doesn't work on Ubuntu/Debian

Please see https://github.com/haiwen/seafile/issues/274

This is because the pre-compiled package is built on CentOS. The libldap we distribute is from CentOS so it search for config files on /etc/openldap/ldap.conf. But Ubuntu/Debian uses /etc/ldap/ldap.conf. So the path to the CA files can't be found on the client.

The work around is

```
mkdir /etc/openldap && ln -s /etc/ldap/ldap.conf /etc/openldap/
```
