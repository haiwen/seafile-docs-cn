# 安装 Seafile 为 Windows 服务

## 将 Seafile 服务器作为 Windows 服务安装的好处 ##

-  在您的所有用户注销后 Seafile 服务器能够继续保持运行  
-  系统启动时，即使没有用户登录， Seafile 服务器也会开始运行  

## 如何作为 Windows 服务安装 ##

- 右击 Seafile 服务器托盘图标，选择"安装为 Windows 服务"选项
- 在弹出的对话框中，点击*是*按钮

如果操作成功，将会弹出一个对话框提示您"已经成功安装 Seafile 服务"。

## 确认 Seafile 服务器已经开始作为 Windows 服务运行 ##

- 注销当前用户
- 在另一台电脑上访问 Seahub 。如果 Seahub 网站仍然可以访问，那么说明 Seafile 服务器已经开始作为 Windows 服务运行  

## 安装为 Windows 服务后如何启动托盘图标##

如果您已经将 Seafile 服务器安装为 Windows 服务，那么在您下次系统启动时， Seafile 服务将会在后台自动运行。这样，当用户登录时， Seafile 服务器托盘图标就不会自动出现。

启动托盘图标，只需双击`C:\SeafileProgram\seafile-server-1.7.0`文件夹下的`run.bat`文件。


## <a id="wiki-uninstall-service"></a> 卸载 Seafile 服务器的 Windows 服务 ##

如果您想卸载 Seafile 服务器的 Windows 服务，请执行以下两步：  

- 右击托盘图标，选择"卸载 Windows 服务"选项
- 在弹出的确认对话框中点击"是"按钮
