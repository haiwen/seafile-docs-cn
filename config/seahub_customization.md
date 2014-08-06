# 个性化 Seahub

## 个性化 Logo 及 CSS 样式

假设你目前在使用 2.1.0 版本。
在 `seafile-server-2.1.0/seahub/media` 下新建 `custom`。将所有的个性化文件放到这个文件夹下。 当你升级到 2.1.1 版本的时候，升级脚本会自动的将此文件夹复制到 `seafile-server-2.1.1/seahub/media` 下。

### 自定义 Logo

1. 将 Logo 文件放在 `seahub/media/custom/` 文件夹下
2. 在 `seahub_settings.py` 中，重新定义 `LOGO_PATH` 的值。

   <pre>
   LOGO_PATH = 'custom/mylogo.png'
   </pre>

3. 在 `seahub_settings.py` 中，重新定义 `LOGO_URL` 的值。

   <pre>
   LOGO_URL = 'http://your-seafile.com'
   </pre>

### 自定义 Seahub CSS 样式

1. 在 `seahub/media/custom/` 中新建 CSS 文件，比如： `custom.css`。
2. 在 `seahub_settings.py` 中，重新定义 `BRANDING_CSS` 的值。

   <pre>
   BRANDING_CSS = 'custom/custom.css'
   </pre>

## 个性化 Seahub 页面

**注意:** 仅支持 2.1 及之后的版本

在 ``<seafile-install-path>/seahub-data/custom`` 目录下，新建 ``templates`` 文件夹。

### 个性化“页脚”页面

1. 复制``seahub/seahub/templates/footer.html`` 到 ``seahub-data/custom/templates``。
2. 自行编写 `footer.html`。

### 个性化“下载”页面

1. 复制 ``seahub/seahub/templates/download.html`` 到 ``seahub-data/custom/templates``。
2. 自行编写 `download.html`。

### 个性化“帮助”页面

1. 复制 ``seahub/seahub/help/templates/help.html``到 ``seahub-data/custom/templates``。
2. 自行编写 `help.html`。
