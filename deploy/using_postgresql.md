# Seafile
## Using PostgreSQL

**Note**: Postgres support is still in Beta status and may have some minor bugs. Please use MySQL in production environment.

## Deploy Seafile with PostgreSQL

## Preparation

1. [[Download and setup seafile server]], then start seafile and seahub and make sure everything is OK.

2. Setup PostgreSQL.

        sudo apt-get install postgresql

3. Create seafile postgres user and required databases. (Obviously you should use a more secure password than seafile)

        sudo -u postgres psql -U postgres -d postgres -c "CREATE USER seafile WITH PASSWORD 'seafile' CREATEDB;"
        createdb ccnet_db -U seafile -W -h localhost
        createdb seafile_db -U seafile -W -h localhost
        createdb seahub_db -U seafile -W -h localhost

3. Create 3 databases named `ccnet_db`, `seafile_db`, `seahub_db`. e.g., ``create database ccnet_db encoding 'utf8';``

## Steps

1. Shutdown services by `./seahub.sh stop` and `./seafile.sh stop`. Then, append the following PostgreSQL configurations to 3 config files (you may need to change to fit your configuration).

    Append following lines to `ccnet/ccnet.conf`:

        [Database]
        ENGINE=pgsql
        HOST=localhost
        USER=seafile
        PASSWD=seafile
        DB=ccnet_db

    Replace the database section in `seafile-data/seafile.conf` with following lines:

        [database]
        type=pgsql
        host=localhost
        user=seafile
        password=seafile
        db_name=seafile_db

    Append following lines to `seahub_settings.py`:

        DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.postgresql_psycopg2',
                'NAME' : 'seahub_db',
                'USER' : 'seafile',
                'PASSWORD' : 'seafile',
                'HOST' : 'localhost',
            }
        }

2. Start seafile by `./seafile.sh start`. There will be several tables created in `ccnet_db` and `seafile_db` if your configuration is correct.

3. Install python-psycopg2 (package name on ubuntu):

        [sudo] apt-get build-dep python-psycopg2

        [sudo] pip install psycopg2

4. Start seahub as follows (assume current path is `/data/haiwen/seafile-server-1.7.0`:

        export CCNET_CONF_DIR=/data/haiwen/ccnet
        export SEAFILE_CONF_DIR=/data/haiwen/seafile-data
        INSTALLPATH=/data/haiwen/seafile-server-1.7.0
        export PYTHONPATH=${INSTALLPATH}/seafile/lib/python2.6/site-packages:${INSTALLPATH}/seafile/lib64/python2.6/site-packages:${INSTALLPATH}/seahub/thirdpart:$PYTHONPATH
        cd seahub
        python manage.py syncdb

    There will be several tables created in `seahub_db`. Then start seahub by `./seahub.sh start`.

## Create Seahub Admin

Assume current path is `/data/haiwen/seafile-server-1.7.0`, and you have exported all the variables above,

    cd seahub
    python manage.py createsuperuser

This command tool will guide you to create a seahub admin.
