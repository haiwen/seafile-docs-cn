### 要求

要想使用 ADFS 登陆到 Seafile，需要以下组件：

1、安装了 [ADFS](https://technet.microsoft.com/en-us/library/hh831502.aspx) 的windows服务器。安装 ADFS 和相关配置详情请参考 [本文](https://msdn.microsoft.com/en-us/library/gg188612.aspx)。

2、对于 ADFS 服务器的SSL有效证书，在这里我们使用 **adfs-server.adfs.com** 作为域名示例。

3、对于 seafile 服务器的SSL有效证书，在这里我们使用 **demo.seafile.com** 作为域名示例。

### 准备证书文件

1、SP(Service Provider) 的 x.509 证书

可以通过以下方式获取：

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout sp.key -out sp.crt
```

x.509 证书用来签署和加密诸如SAML的NameID和Metadata等元素。

然后将这两个文件复制到 **<seafile-install-path>/seahub-data/certs**。如果证书文件夹不存在，请创建它。

2、IdP(Identity Provider) 的 x.509 证书

 1. 登陆到 ADFS 服务器并且打开 ADFS 管理。

 1. 双击 **Service** 并选择 **Certificates**。

 1. 导出 **Token-Signing** 证书：
 
 	1. 右击证书并选择 **View Certificate**。
 	1. 选择 **Details** 选项卡。
 	1. 单击 **Copy to File** (选择 **DER encoded binary X.509**)。

 1. 将此证书转换为PEM格式，重命名为 **idp.crt**

 1. 复制它到 **<seafile-install-path>/seahub-data/certs**。

### 准备 IdP 元数据文件

 1. 打开 https://adfs-server.adfs.com/federationmetadata/2007-06/federationmetadata.xml

 1. 保存这个 xml 文件，重命名为 **idp_federation_metadata.xml**

 1. 复制它到 **<seafile-install-path>/seahub-data/certs**。

### 在 seafile 服务器上安装

- 对于 Ubuntu 16.04
```
sudo apt install libxmlsec1
sudo pip install cryptography djangosaml2
```

### 配置seafile

添加以下配置到 **seahub_settings.py**

```
from os import path
import saml2
import saml2.saml

CERTS_DIR = '<seafile-install-path>/seahub-data/certs'
SP_SERVICE_URL = 'https://demo.seafile.com'
XMLSEC_BINARY = '/usr/local/bin/xmlsec1'
ATTRIBUTE_MAP_DIR = '<seafile-install-path>/seafile-server-latest/seahub-extra/seahub_extra/adfs_auth/attribute-maps'
SAML_ATTRIBUTE_MAPPING = {
    'DisplayName': ('display_name', ),
    'ContactEmail': ('contact_email', ),
    'Deparment': ('department', ),
    'Telephone': ('telephone', ),
}

ENABLE_ADFS_LOGIN = True
EXTRA_AUTHENTICATION_BACKENDS = (
    'seahub_extra.adfs_auth.backends.Saml2Backend',
)
SAML_USE_NAME_ID_AS_USERNAME = True
LOGIN_REDIRECT_URL = '/saml2/complete/'
SAML_CONFIG = {
    # full path to the xmlsec1 binary programm
    'xmlsec_binary': XMLSEC_BINARY,

    'allow_unknown_attributes': True,

    # your entity id, usually your subdomain plus the url to the metadata view
    'entityid': SP_SERVICE_URL + '/saml2/metadata/',

    # directory with attribute mapping
    'attribute_map_dir': ATTRIBUTE_MAP_DIR,

    # this block states what services we provide
    'service': {
        # we are just a lonely SP
        'sp' : {
            "allow_unsolicited": True,
            'name': 'Federated Seafile Service',
            'name_id_format': saml2.saml.NAMEID_FORMAT_EMAILADDRESS,
            'endpoints': {
                # url and binding to the assetion consumer service view
                # do not change the binding or service name
                'assertion_consumer_service': [
                    (SP_SERVICE_URL + '/saml2/acs/',
                     saml2.BINDING_HTTP_POST),
                ],
                # url and binding to the single logout service view
                # do not change the binding or service name
                'single_logout_service': [
                    (SP_SERVICE_URL + '/saml2/ls/',
                     saml2.BINDING_HTTP_REDIRECT),
                    (SP_SERVICE_URL + '/saml2/ls/post',
                     saml2.BINDING_HTTP_POST),
                ],
            },

            # attributes that this project need to identify a user
            'required_attributes': ["uid"],

            # attributes that may be useful to have but not required
            'optional_attributes': ['eduPersonAffiliation', ],

            # in this section the list of IdPs we talk to are defined
            'idp': {
                # we do not need a WAYF service since there is
                # only an IdP defined here. This IdP should be
                # present in our metadata

                # the keys of this dictionary are entity ids
                'https://adfs-server.adfs.com/federationmetadata/2007-06/federationmetadata.xml': {
                    'single_sign_on_service': {
                        saml2.BINDING_HTTP_REDIRECT: 'https://adfs-server.adfs.com/adfs/ls/idpinitiatedsignon.aspx',
                    },
                  'single_logout_service': {
                      saml2.BINDING_HTTP_REDIRECT: 'https://adfs-server.adfs.com/adfs/ls/?wa=wsignout1.0',
                  },
                },
            },
        },
    },

    # where the remote metadata is stored
    'metadata': {
        'local': [path.join(CERTS_DIR, 'idp_federation_metadata.xml')],
    },

    # set to 1 to output debugging information
    'debug': 1,

    # Signing
    'key_file': '', 
    'cert_file': path.join(CERTS_DIR, 'certs/idp.crt'),  # from IdP

    # Encryption
    'encryption_keypairs': [{
        'key_file': path.join(CERTS_DIR, 'certs/sp.key'),  # private part
        'cert_file': path.join(CERTS_DIR, 'certs/sp.crt'),  # public part
    }],

    'valid_for': 24,  # how long is our metadata valid
}

```

### 配置 ADFS 服务

1. 添加 **Relying Party Trust**

 Relying Party Trust 是 Seafile 和 ADFS 之间的连接。

 1. 登陆到 ADFS 服务器并打开 ADFS 管理界面。

 1. 双击 **Trust Relationships**，然后右键 **Relying Party Trusts**，选择 **Add Relying Party Trust…**。

 1. 选择 **Import data about the relying party published online or one a local network**，在 **Federation metadata address** 中输入 `https://demo.seafile.com/saml2/metadata/ `

 1. 然后 **Next** 直到 **Finish**。

1. 添加 **Relying Party Claim Rules**

 `Relying Party Claim Rules` 是用于windows域中seafile和用户的通信。

 **Important**：在windows域中的用户必须要设置了 **E-mail** 值。

 1. 右键点击 relying party trust 并且选择 **Edit Claim Rules...**。

 1. 在 Issuance Transform Rules **Add Rules...**

 1. 选择 **Send LDAP Attribute as Claims** 作为申请规则模版来用。

 1. 给 claim 一个名称，例如：LDAP Attributes。

 1. 将 Attribute Store 设置为 **Active Directory**，LDAP Attribute 设置为 **E-Mail-Addresses**,Outgoing Claim Type 设置为 **E-mail Address**。

 1. 选择 **Finish**。

 1. 再次单击 **Add Rule...**。

 1. 选择 **Transform an Incoming Claim**。

 1. 给它一个名字例如：**Email to Name ID**。

 1. 输入的 claim 类型应该是 **E-mail Address** (它必须跟 rule #1 中的Outgoing Claim Type 相匹配)。

 1. Outgoing claim 的类型是 **Name ID** (这是seafile配置策略中的要求 ` 'name_id_format': saml2.saml.NAMEID_FORMAT_EMAILADDRESS`)。

 1. Outgoing name ID 格式为 **Email**。

 1. **通过所有的 claim 的值** 并且单击 **Finish**。

### 测试

重启服务后，你可以打开一个web浏览器并且输入 `https://demo.seafile.com`,在登陆对话框中应该有一个 `adfs` 按钮。单击该按钮将重定向到 ADFS 服务器(adfs-server.adfs.com),如果用户名密码正确，你将被重定向到seafile主页。

对于descktop客户端，只需要在"Add a new account"窗口点击"Shibboleth Login"，输入 `https://demo.seafile.com`,单击 OK 按钮将会打开一个新的窗口显示ADFS服务的登录页面，如果用户名和密码正确，窗口将关闭并显示seafile资料库面板。



----

- https://support.zendesk.com/hc/en-us/articles/203663886-Setting-up-single-sign-on-using-Active-Directory-with-ADFS-and-SAML-Plus-and-Enterprise-

- http://wiki.servicenow.com/?title=Configuring_ADFS_2.0_to_Communicate_with_SAML_2.0#gsc.tab=0

- https://github.com/rohe/pysaml2/blob/master/src/saml2/saml.py



