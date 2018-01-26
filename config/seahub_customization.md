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

### 个性化 Favicon

1. 将 favicon 文件放在 `seafile-server-latest/seahub/media/custom/` 文件夹下
2. 在 `seahub_settings.py` 中，重新定义 `FAVICON_PATH` 的值。


   ```python
   FAVICON_PATH = 'custom/favicon.png'
   ```

### 自定义 Seahub CSS 样式

1. 在 `seahub/media/custom/` 中新建 CSS 文件，比如： `custom.css`。
2. 在 `seahub_settings.py` 中，重新定义 `BRANDING_CSS` 的值。

   <pre>
   BRANDING_CSS = 'custom/custom.css'
   </pre>

## 个性化 help 页面

首先进入 custom 目录

```
cd <seafile-install-path>/seahub-data/custom
```

运行以下命令，将 install.html 文件复制到 custom/templates/help 目录下

```
mkdir templates
mkdir templates/help
cp ../../seafile-server-latest/seahub/seahub/help/templates/help/install.html
templates/help/
```

编辑 `templates/help/install.html` 文件并保存，就可以看到新的 help 页面了。
