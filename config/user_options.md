# Customize user management

Here we summarize options related to user management in `seahub_settings.py`

    # Enalbe or disalbe registration on web. Default is `False`.
    ENABLE_SIGNUP = False


    # Activate or deactivate user when registration complete. Default is `True`.
    # If set to `False`, new users need to be activated by admin in admin panel.
    ACTIVATE_AFTER_REGISTRATION = False

    # Whether to send email when a system admin adding a new member. Default is `True`.
    # NOTE: since version 1.4.
    SEND_EMAIL_ON_ADDING_SYSTEM_MEMBER = True


    # Attempt limit before showing a captcha when login.
    LOGIN_ATTEMPT_LIMIT = 3

    # Whether a user's session cookie expires when the Web browser is closed.
    SESSION_EXPIRE_AT_BROWSER_CLOSE = False


