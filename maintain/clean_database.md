# 清理数据库

## Seahub

### 清理 Session 数据库

清理 Session 表:

    cd <install-path>/seafile-server-latest
    ./seahub.sh python-env seahub/manage.py clearsessions


### 文件活动 (Activity)

要清理文件活动表，登录到 MySQL/MariaDB，然后使用以下命令:

    use seahub_db;
    DELETE FROM Event WHERE to_days(now()) - to_days(timestamp) > 90;
