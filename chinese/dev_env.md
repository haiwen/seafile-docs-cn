# Seafile
## 建立开发环境的流程

## 从源码编译安装 Seafile 客户端

见 [Build and use seafile client from source]

## 从源码编译安装 Seafile 服务器

见 [Build and deploy seafile server from source]

## 搭建 Seafile Web(Seahub)

### 准备

* Django 1.3 [[https://www.djangoproject.com/download/1.3.5/tarball/]]

* Djblets <pre>sudo easy_install --upgrade Djblets</pre>

* rest_framework [[http://django-rest-framework.org/]]

### 下载Seahub

    git clone git://github.com/haiwen/seahub.git

### 修改配置

修改`setenv.sh`中的`CCNET_CONF_DIR` 以及 `PYTHONPATH`

### 启动

./run-seahub.sh.template

### 验证配置成功

浏览器里输入http://localhost:8000/, 出现登陆页面。

### 创建管理员帐户

执行seahub/tools/下的seahub-admin.py
