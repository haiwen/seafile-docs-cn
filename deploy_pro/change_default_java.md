当您的系统里同时安装了 java 6 及 java 7 的时候，系统默认使用的 java 版本不一定是 java 7.

运行命令 `java -version`， 查看输出：

- 如果输出中显示 **"java version "1.7.0_xx"**, 那么您默认的 java 版本是 java 7. 您可以略过下面的步骤。
- 如果输出中显示 **"java version "1.6.0_xx"**, 那么您默认的 java 版本是 java 6, 需要执行下面的步骤来将默认的 java 配置为 java 7.

在 Debian/Ubuntu 系统中：
```
sudo update-alternatives --config java
```

在 CentOS/RHEL 系统中：
```
sudo alternatives --config java
```

上述的命令会提示您从所以安装的 java 版本中选择一个版本作为默认 java 版本， 请选择 java 7.

完成之后，请再次执行 `java -version` 来确保您的修改已经生效。

[参考链接](http://unix.stackexchange.com/questions/35185/installing-openjdk-7-jdk-does-not-update-java-which-is-still-version-1-6)
