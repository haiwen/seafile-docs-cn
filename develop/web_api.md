# Web API
<p><div class="toc">
<ul>
<li><a href="#seafile-web-api-v2">Seafile Web API V2</a><ul>
<li><a href="#api-basics">API Basics</a></li>
<li><a href="#status-code">Status Code</a></li>
<li><a href="#quick-start">Quick Start</a></li>
<li><a href="#account">Account</a><ul>
<li><a href="#list-accounts">List Accounts</a></li>
<li><a href="#check-account-info">Check Account Info</a></li>
<li><a href="#create-account">Create Account</a></li>
<li><a href="#update-account">Update Account</a></li>
<li><a href="#delete-account">Delete Account</a></li>
</ul>
</li>
<li><a href="#starred-files">Starred Files</a><ul>
<li><a href="#list-starred-files">List starred files</a></li>
<li><a href="#star-a-file">Star A File</a></li>
<li><a href="#unstar-a-file">Unstar A File</a></li>
</ul>
</li>
<li><a href="#user-messages">User Messages</a><ul>
<li><a href="#list-user-messages">List User Messages</a></li>
<li><a href="#reply-a-user-message">Reply A User Message</a></li>
<li><a href="#count-unseen-messages">Count Unseen Messages</a></li>
</ul>
</li>
<li><a href="#group">Group</a><ul>
<li><a href="#list-groups">List Groups</a></li>
<li><a href="#add-a-group">Add A Group</a></li>
<li><a href="#delete-group">Delete Group</a></li>
<li><a href="#rename-group">Rename Group</a></li>
<li><a href="#group-member">Group Member</a><ul>
<li><a href="#add-a-group-member">Add A Group Member</a></li>
<li><a href="#delete-a-group-member">Delete A Group Member</a></li>
</ul>
</li>
<li><a href="#group-message">Group Message</a><ul>
<li><a href="#get-group-messages">Get Group Messages</a></li>
<li><a href="#get-group-message-detail">Get Group Message Detail</a></li>
<li><a href="#send-a-group-message">Send A Group Message</a></li>
<li><a href="#reply-a-group-message">Reply A Group Message</a></li>
<li><a href="#get-group-message-replies">Get Group Message Replies</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#share">Share</a><ul>
<li><a href="#file-share-link">File Share Link</a><ul>
<li><a href="#list-file-share-links">List File Share Links</a></li>
<li><a href="#create-file-share-link">Create File Share Link</a></li>
<li><a href="#delete-file-share-link">Delete File Share Link</a></li>
</ul>
</li>
<li><a href="#shared-libraries">Shared Libraries</a><ul>
<li><a href="#list-shared-libraries">List Shared Libraries</a></li>
<li><a href="#list-be-shared-libraries">List Be Shared Libraries</a></li>
<li><a href="#share-a-library">Share A Library</a></li>
<li><a href="#unshare-a-library">Unshare A Library</a></li>
</ul>
</li>
<li><a href="#shared-files">Shared Files</a><ul>
<li><a href="#list-shared-files">List Shared Files</a></li>
<li><a href="#download-shared-file">Download Shared File</a></li>
<li><a href="#get-shared-file-detail">Get Shared File Detail</a></li>
<li><a href="#delete-shared-file">Delete Shared File</a></li>
<li><a href="#download-private-shared-file">Download Private Shared File</a></li>
<li><a href="#get-private-shared-file-detail">Get Private Shared File Detail</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#library">Library</a><ul>
<li><a href="#library-1">Library</a><ul>
<li><a href="#get-default-lib">Get Default Library</a></li>
<li><a href="#create-default-lib">Create Default Library</a></li>
<li><a href="#list-libraries">List Libraries</a></li>
<li><a href="#get-library-info">Get Library Info</a></li>
<li><a href="#get-library-owner">Get Library Owner</a></li>
<li><a href="#get-library-history">Get Library History</a></li>
<li><a href="#create-library">Create Library</a></li>
<li><a href="#check/create-sub-library">Check/Create Sub Library</a></li>
<li><a href="#delete-library">Delete Library</a></li>
<li><a href="#decrypt-library">Decrypt Library</a></li>
<li><a href="#create-public-lib">Create Public Library</a></li>
<li><a href="#remove-public-lib">Remove Public Library</a></li>
<li><a href="#fetch-library-download-info">Fetch library download info</a></li>
<li><a href="#list-virtual-libraries">List Virtual Libraries</a></li>
<li><a href="#search-libraries">Search Libraries</a></li>
</ul>
</li>
<li><a href="#file">File</a><ul>
<li><a href="#download-file">Download File</a></li>
<li><a href="#get-file-detail">Get File Detail</a></li>
<li><a href="#get-file-history">Get File History</a></li>
<li><a href="#download-file-revision">Download File From a Revision</a></li>
<li><a href="#create-file">Create File</a></li>
<li><a href="#rename-file">Rename File</a></li>
<li><a href="#move-file">Move File</a></li>
<li><a href="#copy-file">Copy File</a></li>
<li><a href="#revert-file">Revert File</a></li>
<li><a href="#delete-file">Delete File</a></li>
<li><a href="#upload-file">Upload File</a><ul>
<li><a href="#get-upload-link">Get Upload Link</a></li>
<li><a href="#upload-file-1">Upload File</a></li>
</ul>
</li>
<li><a href="#update-file">Update file</a><ul>
<li><a href="#get-update-link">Get Update Link</a></li>
<li><a href="#update-file-1">Update File</a></li>
</ul>
</li>
<li><a href="#get-upload-blocks-link">Get Upload Blocks Link</a></li>
<li><a href="#get-update-blocks-link">Get Update Blocks Link</a></li>
</ul>
</li>
<li><a href="#directory">Directory</a><ul>
<li><a href="#list-directory-entries">List Directory Entries</a></li>
<li><a href="#create-new-directory">Create New Directory</a></li>
<li><a href="#rename-directory">Rename Directory</a></li>
<li><a href="#delete-directory">Delete Directory</a></li>
<li><a href="#download-directory">Download Directory</a></li>
<li><a href="#share-directory">Share Directory</a></li>
<li><a href="#batch-delete">Batch Delete</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#get-avatar">Get Avatar</a><ul>
<li><a href="#get-user-avatar">Get User Avatar</a></li>
<li><a href="#get-group-avatar">Get Group Avatar</a></li>
</ul>
</li>
<li><a href="#get-thumbnail">Get Thumbnail</a><ul>
<li><a href="#get-thumbnail-image">Get Thumbnail Image</a></li>
</ul>
</li>
<li><a href="#list-group-and-contacts">List Group And Contacts</a></li>
<li><a href="#get-file-events">Get File Activities</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</div>
</p>

# <a id="seafile-web-api-v2"></a>Seafile Web API V2 #

## <a id="api-basics"></a>API Basics ##

All API calls must be authenticated with a valid Seafile API key.

    curl -H 'Authorization: Token 24fd3c026886e3121b2ca630805ed425c272cb96' https://cloud.seafile.com/api2/auth/ping/

The api key can be retrieved by the obtain auth api. See the <a href="#quick-start">Quick Start</a> for details.

For each API, we provide `curl` examples to illustrate the usage.


## <a id="status-code"></a>Status Code ##

- 200: OK
- 201: CREATED
- 202: ACCEPTED
- 301: MOVED_PERMANENTLY
- 400: BAD_REQUEST
- 403: FORBIDDEN
- 404: NOT_FOUND
- 409: CONFLICT
- 429: TOO_MANY_REQUESTS
- 440: REPO_PASSWD_REQUIRED
- 441: REPO_PASSWD_MAGIC_REQUIRED
- 500: INTERNAL_SERVER_ERROR
- 520: OPERATION_FAILED

## <a id="quick-start"></a>Quick Start ##

**ping**

    curl https://cloud.seafile.com/api2/ping/

    "pong"

**obtain auth token**

    curl -d "username=username@example.com&password=123456" https://cloud.seafile.com/api2/auth-token/

    {"token": "24fd3c026886e3121b2ca630805ed425c272cb96"}

**auth ping**

    curl -H 'Authorization: Token 24fd3c026886e3121b2ca630805ed425c272cb96' https://cloud.seafile.com/api2/auth/ping/

    "pong"

## <a id="account"></a>Account ##

### <a id="list-accounts"></a>List Accounts ###

**GET** https://cloud.seafile.com/api2/accounts/

**Request parameters**

* start (default to 0)
* limit (default to 100)
* scope (default None, accepted values: 'LDAP' or 'DB')

To retrieve all users, just set both `start` and `limit` to `-1`.

If scope parameter is passed then accounts will be searched inside the specific scope, otherwise it will be used the old approach: first LDAP and, if no account is found, DB. 

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/accounts/

**Sample response**

    [
    {
        "email": "foo@foo.com"
    },
    {
        "email": "bar@bar.com"
    }
    ]

**Errors**

* 403 Permission error, only administrator can perform this action

### <a id="check-account-info"></a>Check Account Info ###

**GET** https://cloud.seafile.com/api2/account/info/


**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/account/info/

**Sample response**

    {
    "usage": 26038531,
    "total": 104857600,
    "email": "user@example.com"
    }

**Errors**

* 403 Invalid token

### <a id="create-account"></a>Create Account ###

**PUT** https://cloud.seafile.com/api2/accounts/{email}/

**Request parameters**

* password
* is_staff (defaults to False)
* is_active (defaults to True)

**Sample request**

    curl -v -X PUT -d "password=123456" -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/accounts/newaccount@gmail.com/

**Sample response**

    ...
    < HTTP/1.0 201 CREATED
    < Location: https://cloud.seafile.com/api2/accounts/newaccount@gmail.com/
    ...

    "success"

**Success**

    Response code 201(Created) is returned and the Location header provides shared link.

**Errors**

* 403 Permission error, only administrator can perform this action

### <a id="update-account"></a>Update Account ###

**PUT** https://cloud.seafile.com/api2/accounts/{email}/

**Request parameters**

* password
* is_staff (defaults to False)
* is_active (defaults to True)

**Sample request**

    curl -v -X PUT -d "password=654321&is_staff=true" -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/accounts/newaccount@gmail.com/

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

    "success"

**Success**

    Response code 200(OK) is returned.

**Errors**

* 400 Bad Request, keyword password is required
* 403 Permission error, only administrator can perform this action

### <a id="delete-account"></a>Delete Account ###

**DELETE** https://cloud.seafile.com/api2/accounts/{email}/


**Sample request**

    curl -v -X DELETE -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/accounts/newaccount@gmail.com/

**Sample response**

    "success"

**Errors**

* 403 Permission error, only administrator can perform this action

## <a id="starred-files"></a>Starred Files ##

### <a id="list-starred-files"></a>List starred files

**GET** https://cloud.seafile.com/api2/starredfiles/


**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e6199b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/starredfiles/

**Sample response**

    [
    {
        "repo": "99b758e6-91ab-4265-b705-925367374cf0",
        "mtime": 1355198150,
        "org": -1,
        "path": "/foo/bar.doc",
        "dir": false,
        "size": 0
    },
    {
        "repo": "99b758e6-91ab-4265-b705-925367374cf0",
        "mtime": 1353751237,
        "org": -1,
        "path": "/add_folder-blue.png",
        "dir": false,
        "size": 3170
    }
    ]

### <a id="star-a-file"></a>Star A File

**POST** https://cloud.seafile.com/api2/starredfiles/

**Request parameters**

* repo_id (post)
* p (post)

**Sample request**

    curl -v -d "repo_id=dae8cecc-2359-4d33-aa42-01b7846c4b32&p=/foo.md" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/starredfiles/

**Sample response**

    ...
    < HTTP/1.0 201 CREATED
    < Location: https://cloud.seafile.com/api2/starredfiles/
    ...
    "success"

**Success**

   Response code is 201(Created) and Location header provides url of starred file list.

**Errors**

* 400 `repo_id` or `p` is missing, or `p` is not valid file path(e.g. /foo/bar/).

### <a id="unstar-a-file"></a>Unstar A File

**DELETE** https://cloud.seafile.com/api2/starredfiles/

**Request parameters**

* repo_id
* p

**Sample request**

    curl -X DELETE -v  -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' 'https://cloud.seafile.com/api2/starredfiles/?repo_id=dae8cecc-2359-4d33-aa42-01b7846c4b32&p=/foo.md'

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...
    "success"

**Success**

   Response code is 200(OK), and a string named "success" is returned.

**Errors**

* 400 `repo_id` or `p` is missing, or `p` is not valid file path(e.g. /foo/bar/).

## <a id="user-messages"></a>User Messages ##

### <a id="list-user-messages"></a>List User Messages ###

**GET** https://cloud.seafile.com/api2/user/msgs/{id_or_email}/

**Request parameters**

* id_or_email

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/user/msgs/2/"

**Sample response**

    {
        "to_email": "user@example.com",
        "next_page": -1,
        "msgs": [
            {
                "attachments": [
                    {
                        "path": "/123.md",
                        "repo_id": "c7436518-5f46-4296-97db-2fcba4c8c8db"
                    }
                ],
                "timestamp": 1398233096,
                "from_email": "user@example.com",
                "msgid": 3,
                "msg": "another test msg",
                "nickname": "user"
            },
            {
                "attachments": [],
                "timestamp": 1398233067,
                "from_email": "user@example.com",
                "msgid": 2,
                "msg": "a test msg",
                "nickname": "user"
            }
        ]
    }

**Errors**

* 404 user not found

### <a id="reply-a-user-message"></a>Reply A User Message ###

**POST** https://cloud.seafile.com/api2/user/msgs/{id_or_email}/

**Request parameters**

* id_or_email
* message

**Sample request**

    curl -d "message=this is a user msg reply" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/user/msgs/2/"

**Sample response**

    {
        "msgid": 4
    }

**Errors**

* 404 user not found

### <a id="count-unseen-messages"></a>Count Unseen Messages ##

**GET** https://cloud.seafile.com/api2/unseen_messages/


**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/unseen_messages/"

**Sample response**

    {
        "count": 1
    }

## <a id="group"></a>Group ##

### <a id="list-groups"></a>List Groups ###

**GET** https://cloud.seafile.com/api2/groups/


**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/"

**Sample response**

    {
        "replynum": 0,
        "groups": [
            {
                "ctime": 1398134171327948,
                "creator": "user@example.com",
                "msgnum": 0,
                "mtime": 1398231100,
                "id": 1,
                "name": "lian"
            },
            {
                "ctime": 1398236081042441,
                "creator": "user@example.com",
                "msgnum": 0,
                "mtime": 0,
                "id": 2,
                "name": "123"
            }
        ]
    }

### <a id="add-a-group"></a>Add A Group ###

**PUT** https://cloud.seafile.com/api2/groups/

**Request parameters**

* group_name

**Sample request**

    curl -X PUT -d "group_name=newgroup" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/"

**Sample response**

    {"group_id": 3, "success": true}

**Errors**

* 400 There is already a group with that name.

### <a id="delete-group"></a>Delete Group ###

**DELETE** https://cloud.seafile.com/api2/groups/{group_id}/

**Request parameters**

None

**Sample request**

    curl -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/1/"
    
**Success**

200 if everything is fine.

**Errors**

* 400 if ad group id format
* 404 if Group not found
* 403 if Forbid to delete group
* 520 if Failed to remove group (generic error)

### <a id="rename-group"></a>Rename Group

**POST** https://cloud.seafile.com/api2/groups/{group_id}/

**Request parameters**

* operation (value must be 'rename')
* newname (the new name for the group)

**Sample request**

    curl -d "operation=rename&newname=pinkfloyd_lovers" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/1/"

**Success**

   200 if everything is fine.

**Errors**

* 404 if Group not found
* 403 if Forbid to rename group
* 400 if Newname is missing or if Group name is not valid of if There is already a group with that name or Operation can only be rename.

### <a id="group-member"></a>Group Member ###

#### <a id="add-a-group-member"></a>Add A Group Member ####

**PUT** https://cloud.seafile.com/api2/groups/{group_id}/members/

**Request parameters**

* user_name

**Sample request**

    curl -X PUT -d "user_name=user@example.com"-H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/1/members/"

**Sample response**

    {"success": true}

**Errors**

* 400 invalid group id
* 403 only administrators can add group members
* 404 unable to find group

#### <a id="delete-a-group-member"></a>Delete A Group Member ####

**DELETE** https://cloud.seafile.com/api2/groups/{group_id}/members/

**Request parameters**

* user_name

**Sample request**

    curl -X DELETE -d "user_name=user@example.com" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groups/1/members/"

**Sample response**

    {"success": true}

**Errors**

* 400 invalid group id
* 403 only administrators can remove group members
* 404 unable to find group

### <a id="group-message"></a>Group Message ###

#### <a id="get-group-messages"></a>Get Group Messages ####

**GET** https://cloud.seafile.com/api2/group/msgs/{group_id}/

**Request parameters**

* group_id

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/group/msgs/1/"

**Sample response**

    {
        "next_page": -1,
        "msgs": [
            {
                "reply_cnt": 0,
                "timestamp": 1398230602,
                "replies": [],
                "from_email": "user@example.com",
                "msgid": 1,
                "msg": "test discuss",
                "nickname": "user"
            }
        ]
    }

#### <a id="get-group-message-detail"></a>Get Group Message Detail ####

**GET** https://cloud.seafile.com/api2/group/{group_id}/msg/{msg_id}/

**Request parameters**

* group_id
* msg_id

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/group/1/msg/1/"

**Sample response**

    {
        "reply_cnt": 2,
        "timestamp": 1398230602,
        "replies": [
            {
                "msg": "this is another test",
                "timestamp": 1398232319,
                "nickname": "user",
                "msgid": 1,
                "from_email": "user@example.com"
            },
            {
                "msg": "this is another test",
                "timestamp": 1398232508,
                "nickname": "user",
                "msgid": 3,
                "from_email": "user@example.com"
            }
        ],
        "from_email": "user@example.com",
        "msgid": 1,
        "msg": "test discuss",
        "nickname": "user"
    }

**Errors**

* 404 message not found

#### <a id="send-a-group-message"></a>Send A Group Message ####

**POST** https://cloud.seafile.com/api2/group/msgs/{group_id}/

**Request parameters**

* message
* group_id
* repo_id(optional)
* path(optional)

**Sample request**

    curl -d "message=this is another test&repo_id=c7436518-5f46-4296-97db-2fcba4c8c8db&path=/123.md" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/group/msgs/1/"

**Sample response**

    {
        "msgid": 3
    }

#### <a id="reply-a-group-message"></a>Reply A Group Message ####

**POST** https://cloud.seafile.com/api2/group/{group_id}/msg/{msg_id}

**Request parameters**

* group_id
* msg_id
* message

**Sample request**

    curl -d "message=this is a reply" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/group/1/msg/1/"

**Sample response**

    {
        "msgid": 3
    }

**Errors**

* 404 message not found

#### <a id="get-group-message-replies"></a>Get Group Message Replies ####

**GET** https://cloud.seafile.com/api2/new_replies/


**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/new_replies/"

**Sample response**

    [
        {
            "reply_cnt": 1,
            "timestamp": 1398231100,
            "replies": [
                {
                    "msg": "@user test reply",
                    "timestamp": 1398234493,
                    "nickname": "123",
                    "msgid": 5,
                    "from_email": "user@example.com"
                }
            ],
            "from_email": "user@example.com",
            "att": {
                "repo": "c7436518-5f46-4296-97db-2fcba4c8c8db",
                "path": "/123.md",
                "type": "file",
                "src": "recommend"
            },
            "msgid": 3,
            "msg": "this is another test",
            "nickname": "user"
        }
    ]

## <a id="share"></a>Share

### <a id="file-share-link"></a>File Share Link ###

#### <a id="list-file-share-links"></a>List File Share Links ####

**GET** https://cloud.seafile.com/api2/shared-links/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-links/"

**Sample response**

    {"fileshares": [{"username": "user@example.com", "repo_id": "a582d3bc-bcf5-421e-9125-741fa56d18d4", "ctime": null, "s_type": "d", "token": "e410827494", "view_cnt": 0, "path": "/123/"}, {"username": "user@example.com", "repo_id": "affc837f-7fdd-4e91-b88a-32caf99897f2", "ctime": null, "s_type": "f", "token": "0ae587a7d1", "view_cnt": 0, "path": "/lian123.md"}]}

#### <a id="create-file-share-link"></a>Create File Share Link ####

**PUT** https://cloud.seafile.com/api2/repos/{repo-id}/file/shared-link/

**Request parameters**

* repo-id
* type
* p (Path to the file)

**Sample request**

Create download link for file

    curl -v  -X PUT -d "type=f&p=/foo.md" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/afc3b694-7d4c-4b8a-86a4-89c9f3261b12/file/shared-link/

Create download link for directory

    curl -v  -X PUT -d "type=d&p=/123/" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/afc3b694-7d4c-4b8a-86a4-89c9f3261b12/file/shared-link/

**Sample response**

    ...
    < HTTP/1.0 201 CREATED
    < Location: https://cloud.seafile.com/f/9b437a7e55/
    ...

**Success**

    Response code 201(Created) is returned and the Location header provides shared link.

**Errors**

* 400 Path is missing
* 500 Internal server error

#### <a id="delete-file-share-link"></a>Delete File Share Link ####

**DELETE** https://cloud.seafile.com/api2/shared-links/?t=0ae587a7d1

**Request parameters**

* t

**Sample request**

    curl -v -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-links/?t=0ae587a7d1"

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

### <a id="shared-libs"></a>Shared Libraries ###

#### <a id="list-shared-libs"></a>List Shared Libraries ####

**GET** https://cloud.seafile.com/api2/shared-repos/

**Sample request**

    curl -v -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/shared-repos/

**Sample response**

    [{"repo_id": "7d42522b-1f6f-465d-b9c9-879f8eed7c6c", "share_type": "personal", "permission": "rw", "encrypted": false, "user": "user@example.com", "last_modified": 1361072500, "repo_desc": "ff", "group_id": 0, "repo_name": "\u6d4b\u8bd5\u4e2d\u6587pdf"}, {"repo_id": "79bb29cd-b683-4844-abaf-433952723ca5", "share_type": "group", "permission": "rw", "encrypted": false, "user": "user@example.com", "last_modified": 1359182468, "repo_desc": "test", "group_id": 1, "repo_name": "test_enc"}]

#### <a id="list-be-shared-libs"></a>List Be Shared Libraries ####

**GET** https://cloud.seafile.com/api2/beshared-repos/


**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/beshared-repos/"

**Sample response**

    "[{"user": "user@example.com", "repo_id": "989e3952-9d6f-4427-ab16-4bf9b53212eb", "share_type": "personal", "permission": "rw", "encrypted": false, "repo_desc": "lib shared to imwhatiam", "enc_version": false, "last_modified": 1398218747, "is_virtual": false, "group_id": 0, "repo_name": "lib shared to imwhatiam"}]"

#### <a id="share-a-library"></a>Share A Library ####

**PUT** https://cloud.seafile.com/api2/shared-repos/{repo-id}/

**Request parameters**

* share_type ('personal', 'group' or 'public')
* user (or users)
* group_id
* permission

If share_type is 'personal' then 'user' or 'users' param are required, if share_type is 'group' then 'group_id' parameter is required. If share_type is 'public' no other params is required.

'user' or 'users' parameters can be a comma separated list of emails, in this case the share will be done for more users at the same time. If a problem is encountered during multiple users sharing then the sharing process is aborted.

**Sample request**

    curl -X PUT -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-repos/7d42522b-1f6f-465d-b9c9-879f8eed7c6c/?share_type=group&user=user@example.com&group_id=1&permission=rw"

**Sample response**

    "success"

#### <a id="unshare-a-library"></a>Unshare A Library ####

**DELETE** https://cloud.seafile.com/api2/shared-repos/{repo-id}/

**Request parameters**

* share_type ('personal', 'group' or 'public')
* user
* group_id

If share_type is 'personal' then 'user' param is required, if share_type is 'group' then 'group_id' parameter is required. If share_type is 'public' no other params is required.

**Sample request**

    curl -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-repos/7d42522b-1f6f-465d-b9c9-879f8eed7c6c/?share_type=personal&user=user@example.com&group_id=0"

**Sample response**

    "success"

### <a id="shared-files"></a>Shared Files ###

#### <a id="list-shared-files"></a>List Shared Files ####

**GET** https://cloud.seafile.com/api2/shared-files/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-files/"

**Sample response**

    {"priv_share_in": [{"s_type": "f", "repo_id": "989e3952-9d6f-4427-ab16-4bf9b53212eb", "permission": "r", "to_user": "user@example.com", "token": "94aace406a", "from_user": "user@example.com", "path": "/lib.md"}], "priv_share_out": [{"s_type": "f", "repo_id": "affc837f-7fdd-4e91-b88a-32caf99897f2", "permission": "r", "to_user": "user@example.com", "token": "b7b31bc39b", "from_user": "user@example.com", "path": "/lian123.md"}]}

#### <a id="download-shared-file"></a>Download Shared File ####

**GET** https://cloud.seafile.com/api2/f/{token}/

**Request parameters**

* token(file share token)

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/f/ad93cd0d66/"

**Sample response**

    "http://192.168.1.101:8082/files/89223601/lib.md"

**Errors**

* 404 repo/token/file not found
* 520 OPERATION FAILED, fail to get file id by path

#### <a id="get-shared-file-detail"></a>Get Shared File Detail ####

**GET** https://cloud.seafile.com/api2/f/{token}/detail/

**Request parameters**

* token(file share token)

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/f/ad93cd0d66/detail/"

**Sample response**

    {"repo_id": "989e3952-9d6f-4427-ab16-4bf9b53212eb", "name": "lib.md", "mtime": 1398218747, "path": "/lib.md", "type": "file", "id": "0000000000000000000000000000000000000000", "size": 0}

**Errors**

* 404 repo/token/file not found
* 520 OPERATION FAILED, fail to get file id by path

#### <a id="delete-shared-file"></a>Delete Shared File ####

**DELETE** https://cloud.seafile.com/api2/shared-files/?t=0ae587a7d1

**Request parameters**

* t

**Sample request**

    curl -v -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/shared-files/?t=94aace406a"

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

#### <a id="download-private-shared-file"></a>Download Private Shared File ####

**GET** https://cloud.seafile.com/api2/s/f/{token}/

**Request parameters**

* token(private file share token)

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/s/f/c5aa5f0219/"

**Sample response**

    "http://192.168.1.101:8082/files/6960d5a4/lib.md"

**Errors**

* 404 repo/token/file not found
* 520 OPERATION FAILED, fail to get file id by path

#### <a id="get-private-shared-file-detail"></a>Get Private Shared File Detail ###

**GET** https://cloud.seafile.com/api2/s/f/{token}/detail/

**Request parameters**

* token(private file share token)

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/s/f/c5aa5f0219/detail/"

**Sample response**

    {"repo_id": "989e3952-9d6f-4427-ab16-4bf9b53212eb", "name": "lib.md", "shared_by": "user@example.com", "mtime": 1398218747, "path": "/lib.md", "type": "file", "id": "0000000000000000000000000000000000000000", "size": 0}

**Errors**

* 404 repo/token/file not found
* 520 OPERATION FAILED, fail to get file id by path

## <a id="library"></a>Library ##

### <a id="library-1"></a>Library

#### <a id="get-default-lib"></a>Get Default Library ###

**GET** https://cloud.seafile.com/api2/default-repo/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/default-repo/"

**Sample response**

    {
        "repo_id": "691b3e24-d05e-43cd-a9f2-6f32bd6b800e",
        "exists": true
    }

#### <a id="create-default-lib"></a>Create Default Library ###

**POST** https://cloud.seafile.com/api2/default-repo/

**Sample request**

    curl -X POST -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/default-repo/"

**Sample response**

    {
        "repo_id": "691b3e24-d05e-43cd-a9f2-6f32bd6b800e",
        "exists": true
    }

#### <a id="list-libraries"></a>List Libraries ###

**GET** https://cloud.seafile.com/api2/repos/

**Sample request**

    curl -H 'Authorization: Token 24fd3c026886e3121b2ca630805ed425c272cb96' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/

**Sample response**

    [
    {
        "permission": "rw",
        "encrypted": false,
        "mtime": 1400054900,
        "owner": "user@mail.com",
        "id": "f158d1dd-cc19-412c-b143-2ac83f352290",
        "size": 0,
        "name": "foo",
        "type": "repo",
        "virtual": false,
        "desc": "new library",
        "root": "0000000000000000000000000000000000000000"
    },
    {
        "permission": "rw",
        "encrypted": false,
        "mtime": 1400054802,
        "owner": "user@mail.com",
        "id": "0536b11a-a5fd-4482-9314-728cb3472f54",
        "size": 0,
        "name": "foo",
        "type": "repo",
        "virtual": false,
        "desc": "new library",
        "root": "0000000000000000000000000000000000000000"
    }
    ]

#### <a id="get-library-info"></a>Get Library Info ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/

**Request parameters**

* repo-id

**Sample request**

    curl -G -H 'Authorization: Token 24fd3c026886e3121b2ca630805ed425c272cb96' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/632ab8a8-ecf9-4435-93bf-f495d5bfe975/

**Sample response**

    {
    "encrypted": false,
    "password_need": null,
    "mtime": null,
    "owner": "self",
    "id": "632ab8a8-ecf9-4435-93bf-f495d5bfe975",
    "size": 1356155,
    "name": "org",
    "root": "b5227040de360dd22c5717f9563628fe5510cbce",
    "desc": "org file",
    "type": "repo"
    }

#### <a id="get-library-owner"></a>Get Library Owner ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/owner/

**Request parameters**

* repo-id

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/owner/

**Sample response**

    {
    "owner": "user@example.com"
    }

**Errors**

* 403 Permission error, only administrator can perform this action

#### <a id="get-library-history"></a>Get Library History ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/history/

**Request parameters**

* repo-id

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/history/

**Sample response**

    {"commits": [{"rev_file_size": 0, "rev_file_id": null, "ctime": 1398045167, "creator_name": "imwhatiam123@gmail.com", "creator": "0000000000000000000000000000000000000000", "root_id": "ca2625da6be6e211ddd584615ef3bfaa531e66aa", "rev_renamed_old_path": null, "parent_id": "205c469f0830df09b13024601524058757a43128", "new_merge": false, "repo_id": "691b3e24-d05e-43cd-a9f2-6f32bd6b800e", "desc": "Modified \"api.md\"", "id": "eb62721812e0c3122889b5facde971b353ad176b", "conflict": false, "second_parent_id": null}, {"rev_file_size": 0, "rev_file_id": null, "ctime": 1398045158, "creator_name": "imwhatiam123@gmail.com", "creator": "0000000000000000000000000000000000000000", "root_id": "0b7a31adf4ea8b29ad5a5920420b548da11dd32f", "rev_renamed_old_path": null, "parent_id": "2ba85ee6072efea51a3483843ea7de9b6d1d1eb2", "new_merge": false, "repo_id": "691b3e24-d05e-43cd-a9f2-6f32bd6b800e", "desc": "Added \"api.md\"", "id": "205c469f0830df09b13024601524058757a43128", "conflict": false, "second_parent_id": null}], "page_next": false}

#### <a id="create-library"></a>Create Library ###

**POST** https://cloud.seafile.com/api2/repos/

**Request parameters**

* name
* desc (defaults to "new repo")
* passwd (needed by encrypt library)

**Sample request**

    curl -v -d "name=foo&desc=new library" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/

**Sample response**

    {
    "encrypted": "",
    "enc_version": 0,
    "repo_id": "f15811fd-5c19-412c-b143-2ac83f352290",
    "magic": "",
    "relay_id": "c5e41170db250ea497075e2911104faf0105b7fb",
    "repo_version": 1,
    "relay_addr": "cloud.seafile.com",
    "token": "c1f3defe9ba408cd7964427ec276843e9d10c23b",
    "relay_port": "10001",
    "random_key": "",
    "email": "user@mail.com",
    "repo_name": "foo"
    }

**Success**

   Response code 200 and newly created library information are returned.

**Errors**

* 400 Library name missing.
* 520 Operation failed.

#### <a id="check/create-sub-library"></a>Check/Create Sub Library ###

check if a dir has a corresponding sub_repo, if it does not have, create one

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/dir/sub_repo/?p=/\&name=sub_lib

**Request parameters**

* repo-id
* p
* name

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/sub_repo/?p=/\&name=sub_lib

**Sample response**

    {"sub_repo_id": "c0a3283c-013c-4a7c-8f68-006f06fa6dec"}

**Errors**

* 400 Argument missing
* 500 INTERNAL SERVER ERROR

#### <a id="delete-library"></a>Delete Library ###

**DELETE** https://cloud.seafile.com/api2/repos/{repo-id}/

**Sample request**

    curl -v -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/8f5f2222-72a8-454f-ac40-8397c5a556a8/

**Sample response**

"success"

**Errors**

* 400 Library does not exist.

* 403 Only library owner can perform this operation.

#### <a id="decrypt-library"></a>Decrypt Library ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/

**Request parameters**

* password

**Sample request**

    curl -v -d "password=123" -H 'Authorization: Token e6a33d61954f219a96b60f635cf02717964e4385' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/0c2465a5-4753-4660-8a22-65abec9ec8d0/

**Sample response**

"success"

**Errors**

* 400 Incorrect password
* 409 Repo is not encrypt
* 500 Internal server error


#### <a id="create-public-lib"></a>Create Public Library ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/public/

**Request parameters**

* repo-id

**Sample request**

    curl -X POST -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/public/

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

**Success**

    Response code is 200(OK), and a string "success" is returned.

**Errors**

* 404 Repo not found
* 403 Forbid to access this repo
* 500 INTERNAL SERVER ERROR, Unable to make repo public

#### <a id="remove-public-lib"></a>Remove Public Library ###

**DELETE** https://cloud.seafile.com/api2/repos/{repo-id}/public/

**Request parameters**

* repo-id

**Sample request**

    curl -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/public/

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

**Success**

    Response code is 200(OK), and a string "success" is returned.

**Errors**

* 404 Repo not found
* 403 Forbid to access this repo
* 500 INTERNAL SERVER ERROR, Unable to remove public repo

#### <a id="fetch-library-download-info"></a>Fetch library download info ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/download-info/

**Request parameters**

* repo-id

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/download-info/

**Sample response**

    {
    "applet_root": "https://localhost:13420",
    "relay_addr": "localhost",
    "token": "46acc4d9ca3d6a5c7102ef379f82ecc1edc629e1",
    "repo_id": "dae8cecc-2359-4d33-aa42-01b7846c4b32",
    "relay_port": "10002",
    "encrypted": "",
    "repo_name": "test",
    "relay_id": "8e4b13b49ca79f35732d9f44a0804940d985627c",
    "email": "user@example.com"
    }

#### <a id="list-virtual-libraries"></a>List Virtual Libraries ###

**GET** https://cloud.seafile.com/api2/virtual-repos/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/virtual-repos/"

**Sample response**

    {"virtual-repos":
        [
            {"virtual_perm": "rw", "store_id": null, "worktree_invalid": false, "encrypted": false, "origin_repo_name": "lian", "last_modify": 0, "no_local_history": false, "head_branch": null, "last_sync_time": 0, "id": "51344de8-456f-4dc7-ac08-718827994252", "size": 0, "share_permission": null, "worktree_changed": false, "worktree_checktime": 0, "origin_path": "/lian", "is_virtual": true, "origin_repo_id": "a582d3bc-bcf5-421e-9125-741fa56d18d4", "version": 1, "random_key": null, "is_original_owner": true, "shared_email": null, "enc_version": 0, "head_cmmt_id": "bc666fdc60d2352b9f6a0324ac64168d43724eed", "desc": null, "index_corrupted": false, "magic": null, "name": "lian", "worktree": null, "auto_sync": false, "relay_id": null},
            {"virtual_perm": "rw", "store_id": null, "worktree_invalid": false, "encrypted": false, "origin_repo_name": "lian", "last_modify": 0, "no_local_history": false, "head_branch": null, "last_sync_time": 0, "id": "c0a3283c-013c-4a7c-8f68-006f06fa6dec", "size": 0, "share_permission": null, "worktree_changed": false, "worktree_checktime": 0, "origin_path": "/", "is_virtual": true, "origin_repo_id": "a582d3bc-bcf5-421e-9125-741fa56d18d4", "version": 1, "random_key": null, "is_original_owner": true, "shared_email": null, "enc_version": 0, "head_cmmt_id": "ff18229aadc9acc73ad481278d5b4c42b3353aa0", "desc": null, "index_corrupted": false, "magic": null, "name": "123", "worktree": null, "auto_sync": false, "relay_id": null}
        ]
    }

#### <a id="search-libraries"></a>Search Libraries ###

**GET** https://cloud.seafile.com/api2/search/

**Request parameters**

* q
* per_page (optional)

**Sample request**

    curl -G -H 'Authorization: Token 24fd3c026886e3121b2ca630805ed425c272cb96' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/search/?q=keyword

**Sample response**

    {
        "has_more": false,
        "total": 3,
        "results": [
            {
                "repo_id": "691b3e24-d05e-43cd-a9f2-6f32bd6b800e",
                "name": "api.md",
                "oid": "8ea78453bb474359cd9d8e2c4c4d8d9cbdcef0a2",
                "last_modified": 1398045167,
                "fullpath": "/api.md",
                "size": 18939
            },
            {
                "repo_id": "c5509062-9bca-4933-a7e0-c6da1d5f82be",
                "name": "home.md",
                "oid": "dda57aaffa5179829e064c7d0c142f47a8a65d3b",
                "last_modified": 1397096831,
                "fullpath": "/home.md",
                "size": 1954
            },
            {
                "repo_id": "c5509062-9bca-4933-a7e0-c6da1d5f82be",
                "name": "\u5e38\u89c1\u5b89\u88c5\u95ee\u9898.md",
                "oid": "8573f982eeb478b932a55ec13218f4f90a7c5a27",
                "last_modified": 1397188959,
                "fullpath": "/\u5e38\u89c1\u5b89\u88c5\u95ee\u9898.md",
                "size": 1050
            }
        ]
    }

**Errors**

* 404 Search not supported.
* 400 Missing argument q.

### <a id="file"></a>File ##

#### <a id="download-file"></a>Download File  ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo

**Request parameters**

* repo-id
* p

**Sample request**

    curl  -v  -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/?p=/foo.c

**Sample response**

    "https://cloud.seafile.com:8082/files/adee6094/foo.c"

**Errors**

* 400 Path is missing
* 404 File not found
* 520 Operation failed.

#### <a id="get-file-detail"></a>Get File Detail ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/file/detail/?p=/foo.c

* repo-id
* p

**Sample request**

    curl -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/detail/?p=/foo.c

**Sample response**

    {
    "id": "013d3d38fed38b3e8e26b21bb3463eab6831194f",
    "mtime": 1398148877,
    "type": "file",
    "name": "foo.py",
    "size": 22
    }

**Errors**

* 400 Path is missing
* 520 Operation failed.

#### <a id="get-file-history"></a>Get File History ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/file/history/?p=/foo.c

**Request parameters**

* repo-id
* p

**Sample request**

    curl -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/history/?p=/foo.c

**Sample response**

    {
    "commits":
        [
            {
            "rev_file_size": 0,
            "repo_id": "a582d3bc-bcf5-421e-9125-741fa56d18d4",
            "ctime": 1398149763,
            "creator_name": "user@example.com",
            "creator": "0000000000000000000000000000000000000000",
            "root_id": "b64d413d9894c9206beac3faf9c2a0d75b4a8ebf",
            "rev_renamed_old_path": null,
            "parent_id": "8e546762e1657ab22dad83e9cb1e5ea31a767c9a",
            "new_merge": false,
            "version": 1,
            "conflict": false,
            "desc": "Added \"foo.c\"",
            "id": "9464f7499bfa7363d563282361339eaf96a93318",
            "rev_file_id": "0000000000000000000000000000000000000000",
            "second_parent_id": null
            },
            {
            "rev_file_size": 0,
            "repo_id": "a582d3bc-bcf5-421e-9125-741fa56d18d4",
            "ctime": 1398146059,
            "creator_name": "user@example.com",
            "creator": "0000000000000000000000000000000000000000",
            "root_id": "572413414257c76039897e00aeb35f819471206b",
            "rev_renamed_old_path": null,
            "parent_id": "f977bdb0ebb205645c3b42216c2817e511c3f68f",
            "new_merge": false,
            "version": 1,
            "conflict": false,
            "desc": "Added \"foo.c\"",
            "id": "a1ec20709675f4dc8db825cdbca296be245d189b",
            "rev_file_id": "0000000000000000000000000000000000000000",
            "second_parent_id": null
            }
        ]
    }

**Errors**

* 400 Path is missing
* 404 File not found

#### <a id="download-file-revision"></a>Download File From a Revision ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/file/revision/?p=/foo.c&commit_id=a1ec20709675f4dc8db825cdbca296be245d189b

**Request parameters**

* repo-id
* p
* commit_id

**Sample request**

    curl -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/revision/?p=/foo.c\&commit_id=a1ec20709675f4dc8db825cdbca296be245d189b

**Sample response**

    "https://cloud.seafile.com:8082/files/adee6094/foo.c"

**Errors**

* 400 Path is missing
* 404 Revision not found

#### <a id="create-file"></a>Create File  ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo.c

**Request parameters**

* repo-id
* p
* operation

**Sample request**

    curl -v -d "operation=create" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/?p=/foo.c

**Sample response**

    ...
    < HTTP/1.1 201 CREATED
    ...
    "success"

**Success**

   Response code is 201, and a string `"success"` is returned.

**Errors**

* 403 FORBIDDEN, You do not have permission to move file
* 520 OPERATION FAILED, fail to create file

#### <a id="rename-file"></a>Rename File  ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo.c

**Request parameters**

* repo-id
* p
* operation
* newname

**Sample request**

    curl -v -d "operation=rename&newname=newfoo.c" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/?p=/foo.c

**Sample response**

    ...
    < HTTP/1.1 301 MOVED PERMANENTLY
    ...
    "success"

**Success**

   Response code is 301, and a string `"success"` is returned.

**Errors**

* 400 BAD REQUEST, Path is missing or invalid(e.g. p=/) or newname is missing(newname too long)
* 403 FORBIDDEN, You do not have permission to rename file
* 404 NOT FOUND, repo not found
* 409 CONFLICT, the newname is the same to the old
* 520 OPERATION FAILED, fail to rename file

#### <a id="move-file"></a>Move File  ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo.c

**Request parameters**

* repo-id
* p
* operation
* dst_repo
* dst_dir

**Sample request**

    curl -v -d "operation=move&dst_repo=affc837f-7fdd-4e91-b88a-32caf99897f2&dst_dir=/" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/?p=/foo.c

**Sample response**

    ...
    < HTTP/1.1 301 MOVED PERMANENTLY
    ...
    "success"

**Success**

   Response code is 301, and a string `"success"` is returned.

**Errors**

* 400 BAD REQUEST, Path is missing or invalid(e.g. p=/)
* 403 FORBIDDEN, You do not have permission to move file
* 404 NOT FOUND, repo not found
* 500 INTERNAL SERVER ERROR

#### <a id="copy-file"></a>Copy File ###

**POST** https://cloud.seafile.com/api2/repos/{repo_id}/fileops/copy/

**Request parameters**

* p: source folder path, defaults to `"/"`
* file_names: list of file/folder names to copy. Multiple file/folder names can be seperated by `:`.
* dst_repo: the destination repo id
* dst_dir: the destination folder in `dst_repo`

**Sample request**

    curl -d "dst_repo=73ddb2b8-dda8-471b-b7a7-ca742b07483c&dst_dir=/&file_names=foo.c" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/repos/c7436518-5f46-4296-97db-2fcba4c8c8db/fileops/copy/

**Sample response**

    "success"

**Errors**

* 400 missing argument
* 403 You do not have permission to copy file
* 404 repo not found
* 502 failed to copy file

#### <a id="revert-file"></a>Revert File ###

**PUT** https://cloud.seafile.com/api2/repos/{repo_id}/file/revert/

**Request parameters**

* repo_id
* p
* commit_id

**Sample request**

    curl -v -X PUT -d "commit_id=a1ec20709675f4dc8db825cdbca296be245d189b&p=/foo.c" -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/8f5f2222-72a8-454f-ac40-8397c5a556a8/file/revert/

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

    {"ret": 0}

**Success**

    Response code 200(OK) is returned.

**Errors**

* 400 Path is missing

#### <a id="delete-file"></a>Delete File ###

**DELETE** https://cloud.seafile.com/api2/repos/{repo-id}/file/?p=/foo

**Request parameters**

* repo-id
* p

**Sample request**

    curl -X DELETE -v  -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/file/?p=/foo.c

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...
    "success"

**Errors**

* 400 Path is missing
* 520 Operation failed.

**Note**

   This can also be used to delete directory.

#### <a id="upload-file"></a>Upload File ###

##### <a id="get-upload-link"></a>Get Upload Link

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/upload-link/

**Request parameters**

* repo-id

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/upload-link/

**Sample response**

    "http://cloud.seafile.com:8082/upload-api/ef881b22"

**Errors**

    500 Run out of quota

##### <a id="upload-file-1"></a>Upload File

After getting the upload link, POST to this link for uploading files.

**POST** http://cloud.seafile.com:8082/upload-api/ef881b22

**Errors**

    400 Bad request
    440 Invalid filename
    441 File already exists
    500 Internal server error

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -F file=@test.txt -F filename=test.txt -F parent_dir=/ http://cloud.seafile.com:8082/upload-api/ef881b22

**Sample response**

    "adc83b19e793491b1c6ea0fd8b46cd9f32e592fc"

**Note**

For python client uploading, see <https://cloud.seafile.com/f/1b0ade6edc/>

#### <a id="update-file"></a>Update file ###

##### <a id="get-update-link"></a>Get Update Link

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/update-link/

**Request parameters**

* repo-id

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/update-link/

**Sample response**

    "http://cloud.seafile.com:8082/update-api/ef881b22"

**Errors**

    500 Run out of quota

##### <a id="update-file-1"></a>Update File

After getting the upload link, POST to this link for uploading files.

**POST** http://cloud.seafile.com:8082/update-api/ef881b22

**Request parameters**

* target_file

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" -F file=@test.txt -F filename=test.txt -F target_file=/test.txt http://cloud.seafile.com:8082/upload-api/ef881b22

**Returns**

The id of the updated file

**Sample response**

    "adc83b19e793491b1c6ea0fd8b46cd9f32e592fc"

**Errors**

- 400 Bad request
- 440 Invalid filename
- 500 Internal server error

#### <a id="get-upload-blks-link"></a>Get Upload Blocks Link

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/upload-blks-link/

**Request parameters**

* repo-id

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/upload-blks-link/

**Sample response**

    "https://cloud.seafile.com/seafhttp/upload-blks-api/c1e6823d"

**Errors**

- 403 Can not access repo
- 520 above quota

#### <a id="get-update-blks-link"></a>Get Update Blocks Link

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/update-blks-link/

**Request parameters**

* repo-id

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd" https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/update-blks-link/

**Sample response**

    "https://cloud.seafile.com/seafhttp/update-blks-api/c1e6823d"

**Errors**

- 403 Can not access repo
- 520 above quota

### <a id="directory">Directory ##

#### <a id="list-directory-entries"></a>List Directory Entries ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/dir/

* repo-id
* p (optional): The path to a directory. If `p` is missing, then defaults to '/' which is the top directory.
* oid (optional)

**Sample request**

    curl -H "Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d9b477fd" -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api2/repos/99b758e6-91ab-4265-b705-925367374cf0/dir/?p=/foo

**Sample response**

   If oid is the latest oid of the directory, returns `"uptodate"` , else returns

    [
    {
        "id": "0000000000000000000000000000000000000000",
        "type": "file",
        "name": "test1.c",
        "size": 0
    },
    {
        "id": "e4fe14c8cda2206bb9606907cf4fca6b30221cf9",
        "type": "dir",
        "name": "test_dir"
    }
    ]

**Errors**

* 404 The path is not exist.
* 440 Repo is encrypted, and password is not provided.
* 520 Operation failed..

#### <a id="create-new-directory"></a>Create New Directory ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/dir/

* repo-id
* p
* operation=mkdir (post)

**Sample request**

    curl -d  "operation=mkdir" -v  -H 'Authorization: Tokacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/?p=/foo

**Sample response**

    ...
    < HTTP/1.0 201 CREATED
    < Location: https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/?p=/foo
    ...

    "success"

**Success**

   Response code 201(Created) is returned, and Location header provides the url of created directory.

**Errors**

* 400 Path is missing or invalid(e.g. p=/)
* 520 Operation failed.

**Notes**

   Newly created directory will be renamed if the name is duplicated.
   
#### <a id="rename-directory"></a>Rename Directory ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/dir/

**Parameters**

* p (path)
* operation=rename (post)
* newname (the new name for directory)

**Sample request**

    curl -d  "operation=rename&newname=pinkfloyd_newfolder" -v  -H 'Authorization: Tokacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/?p=/foo

**Success**

   Response code 200 if everything is ok

**Errors**

* 403 if You do not have permission to rename a folder
* 400 if newname is not given
* 520 if Failed to rename directory (generic problem)

**Notes**

   If the new name is the same of the old name no operation will be done.

#### <a id="delete-directory"></a>Delete Directory ###

**DELETE** https://cloud.seafile.com/api2/repos/{repo-id}/dir/

* repo-id
* p

**Sample request**

    curl -X DELETE -v  -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/?p=/foo

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...
    "success"

**Success**

   Response code is 200(OK), and a string `"success"` is returned.

**Errors**

* 400 Path is missing or invalid(e.g. p=/)
* 520 Operation failed.

**Note**

   This can also be used to delete file.

#### <a id="Download-directory"></a>Download Directory ###

**GET** https://cloud.seafile.com/api2/repos/{repo-id}/dir/download/?p=/foo

* repo-id
* p

**Sample request**

    curl -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/?p=/foo

**Sample response**

    "https://cloud.seafile.com:8082/files/adee6094/foo"

**Errors**

* 400 Path is missing or invalid(e.g. p=/), or unable to download directory, size is too large
* 404 Repo(path) not found(exist)
* 520 Operation failed.

#### <a id="share-directory"></a>Share Directory ###

**POST** https://cloud.seafile.com/api2/repos/{repo-id}/dir/share/

* repo-id
* emails
* s_type
* path
* perm

**Sample request**

    curl -v -X POST -d "emails=user@example.com&s_type=d&path=/dir&perm=r" -H 'Authorization: Token f2210dacd3606d94ff8e61d99b477fd' -H 'Accept: application/json; charset=utf-8; indent=4' https://cloud.seafile.com/api2/repos/dae8cecc-2359-4d33-aa42-01b7846c4b32/dir/share/

**Sample response**

    ...
    < HTTP/1.0 200 OK
    ...

**Success**

   Response code is 200(OK).

#### <a id="batch-delete"></a>Batch Delete ###

Pipelining over HTTP/1.1 can be used to delete multiple files and directories without losing performance.

A sample request looks like `curl -X DELETE https://cloud.seafile.com/api2/repos/{repo-id}/dir/?p=/foo http://cloud.seafile.com/api2/repos/{repo-id}/dir/?p=/bar`. This code snippet shows how to use Python client to batch delete multiple files and directories. See <http://cloud.seafile.com/f/f7fd5d5b9d/>


## <a id="get-avatar"></a>Get Avatar ##

### <a id="get-user-avatar"></a>Get User Avatar ##

**GET** https://cloud.seafile.com/api2/avatars/user/{user}/resized/{size}/

**Request parameters**

* user
* size

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/avatars/user/user@example.com/resized/80/

**Sample response**

    {
        "url": "http://127.0.0.1:8000/media/avatars/default.png",
        "is_default": true,
        "mtime": 0
    }

### <a id="get-group-avatar"></a>Get Group Avatar ##

**GET** https://cloud.seafile.com/api2/avatars/group/{group_id}/resized/{size}/

**Request parameters**

* group_id
* size

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/avatars/group/1/resized/80/

**Sample response**

    {
        "url": "http://127.0.0.1:8000/media/avatars/groups/default.png",
        "is_default": true,
        "mtime": 0
    }

## <a id="get-thumbnail"></a>Get Thumbnail##

### <a id="get-thumbnail-image"></a>Get Thumbnail Image ##

**GET** https://cloud.seafile.com/api2/repos/{repo_id}/thumbnail/{path}

**Request parameters**

* repo_id
* path
* size

**Sample request**

    curl -H 'Authorization: Token 40f9a510a0629430865dc199a3880898ad2e48fc' https://cloud.seafile.com/api2/repos/fbead5d0-4817-4446-92f3-7ac8e6a8e5f5/thumbnail/5.jpg?s=123 > thumbnail.png

## <a id="list-group-and-contacts"></a>List Group And Contacts ##

**GET** https://cloud.seafile.com/api2/groupandcontacts/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/groupandcontacts/"

**Sample response**

    {
        "contacts": [
            {
                "msgnum": 0,
                "mtime": 0,
                "lastmsg": null,
                "email": "user@example.com",
                "name": "123"
            }
        ],
        "umsgnum": 0,
        "replynum": 0,
        "groups": [
            {
                "ctime": 1398134171327948,
                "creator": "user@example.com",
                "msgnum": 0,
                "mtime": 0,
                "lastmsg": null,
                "id": 1,
                "name": "lian"
            }
        ],
        "gmsgnum": 0,
        "newreplies": []
    }

## <a id="get-file-events"></a>Get File Activities ##

**GET** https://cloud.seafile.com/api2/events/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api2/events/"

**Sample response**

     {"more_offset": 16, "events":[{"repo_id": "6f3d28a4-73ae-4d01-a727-26774379dcb9", "author": "mysnowls@163.com", "nick": "lins05", "time": 1398078909, "etype": "repo-update", "repo_name": "Downloads", "desc": "Added \"seafile-cli_3.0.2_i386.tar.gz\"."},{"repo_id": "6f3d28a4-73ae-4d01-a727-26774379dcb9", "author": "mysnowls@163.com", "nick": "lins05", "time": 1398075540, "etype": "repo-update", "repo_name": "Downloads", "desc": "Added \"seafile-server_3.0.0_x86-64.tar.gz\"."}], "more": false}
