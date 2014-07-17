# Install Seafile Server as a Windows Service

### Why you may want to install Seafile Server as a Windows service

- Seafile Server can keep on running after all users logout
- When system boots up, Seafile Server would start running even if no user has logged in

### Install as a service

- Right click the tray icon, choose __Install as a Windows service__
- Choose ``yes`` in the propmted dialog

If the operation succeeds, A dialog would be prompted saying __Successully installed seafile service__.

### Verify Seafile Server already running as a Windows service

- Logout the current user
- Visit seahub from another computer. If the seahub website can still be visited, Seafile server is already running as a Windows server

### How to start the tray icon after installing as a service

If you have installed seafile server as a service, it would run automatically in the background the next time you boot your system. However, the tray icon would not appear automatically when a user logins in.

To start the tray icon, just doule click the ``run.bat`` file in the folder ``C:\SeafileProgram\seafile-server-1.7.0``
Uninstall Seafile Server Windows service

### If you want to uninstall the Seafile Server service:

- Right click the tray icon, choose "Uninstall Windows service"
- Choose "yes" in the propmted dialog
