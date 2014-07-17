# Seahub customization
## Customize Seahub Logo and Css

Assume that you are using version 2.1.0. Create a folder `custom` under `seafile-server-2.1.0/seahub/media`. Put all the customization files here. The upgrade script will copy the folder to `seafile-server-2.1.1/seahub/media` when you upgrade to version 2.1.1.

### Customize Logo

1. Add your logo file to `seahub/media/custom/`
2. Overwrite `LOGO_PATH` in `seahub_settings.py`

   <pre>
   LOGO_PATH = 'custom/mylogo.png'
   </pre>

3. Overwrite `LOGO_URL` in `seahub_settings.py`

   <pre>
   LOGO_URL = 'http://your-seafile.com'
   </pre>

### Customize Seahub CSS

1. Add your css file to `seahub/media/custom/`, for example, `custom.css`
2. Overwrite `BRANDING_CSS` in `seahub_settings.py`

   <pre>
   BRANDING_CSS = 'custom/custom.css'
   </pre>

## Customize footer and other Seahub Pages

**Note:** Since version 2.1.

Create a foler ``templates`` under ``<seafile-install-path>/seahub-data/custom``

### Customize footer

1. Copy ``seahub/seahub/templates/footer.html`` to ``seahub-data/custom/templates``.
2. Modify `footer.html`.

### Customize Download page

1. Copy ``seahub/seahub/templates/download.html`` to ``seahub-data/custom/templates``.
2. Modify `download.html`.

### Customize Help page

1. Copy ``seahub/seahub/help/templates/help`` to ``seahub-data/custom/templates/help``.
2. Modify pages under `help`.
