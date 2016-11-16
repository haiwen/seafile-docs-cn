# 个性化 Seahub

## 个性化 Logo 及 CSS 样式

创建 ``<seafile-install-path>/seahub-data/custom`` 目录. 在 `seafile-server-latest/seahub/media` 目录下创建一个符号链接： `ln -s ../../../seahub-data/custom custom`.

升级过程中，Seafile 升级脚本会自动创建符号链接以维持个性化设置

### 个性化 Logo

1. 将 Logo 文件放在 `seafile-server-latest/seahub/media/custom/` 文件夹下
2. 在 `seahub_settings.py` 中，重新定义 `LOGO_PATH` 的值。

   ```python
   LOGO_PATH = 'custom/mylogo.png'
   ```

3. 在 `seahub_settings.py` 中，重新定义 Logo 宽高的值。

   ```python
   LOGO_WIDTH = 149
   LOGO_HEIGHT = 32
   ```

### 自定义 Seahub CSS 样式

1. 在 `seahub/media/custom/` 中新建 CSS 文件，比如： `custom.css`。
2. 在 `seahub_settings.py` 中，重新定义 `BRANDING_CSS` 的值。

   <pre>
   BRANDING_CSS = 'custom/custom.css'
   </pre>

## 个性化 Seahub 页面

在 ``<seafile-install-path>/seahub-data/custom`` 目录下，新建 ``templates`` 文件夹。

### 个性化“页脚”页面

**注意:** 6.0 版本之后，Seafile web 页面使用全屏设计, 不再使用页脚。

1. 复制``seahub/seahub/templates/footer.html`` 到 ``seahub-data/custom/templates``。
2. 自行编写 `footer.html`。

### 个性化“下载”页面

1. 复制 ``seahub/seahub/templates/download.html`` 到 ``seahub-data/custom/templates``。
2. 自行编写 `download.html`。

### 个性化“帮助”页面

1. 复制 ``seahub/seahub/help/templates`` 目录到 ``seahub-data/custom/``。
2. 自行编写 `seahub-data/custom/templates/help` 目录下的 html 文件。
