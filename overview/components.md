# Components Overview

Seafile server and client consists of several components. Understanding how they work together will save you a lot time in deploying and maintaining Seafile.

## Server

- **Seahub** (django)：the website. Seafile server package contains a light-weight Python HTTP server gunicorn that serves the website. Seahub runs as an application within gunicorn.
- **HttpServer** (``httpserver``): handles raw file upload/download functions for Seahub. Due to Gunicorn being poor at handling large files, so we wrote this "HttpServer" in the C programming language to serve raw file upload/download.
- **Seafile server** (``seaf-server``)：data service daemon
- **Ccnet server** (``ccnet-server``)：networking service daemon. In our initial design, Ccnet worked like a traffic bus. All the network traffic between client, server and internal traffic between different components would go through Ccnet. After further development we found that file transfer is improved by utilizing the Seafile daemon component directly.

The picture below shows how Seafile desktop client syncs files with Seafile server:

![Seafile Sync](../images/seafile-sync-arch.png)

The picture below shows how Seafile mobile client interacts with Seafile server:

![How mobile clients connect Seafile](../images/mobile-arch.png)

The picture below shows how Seafile mobile client interacts with Seafile server if the server is configured behind Nginx/Apache:

![How seafile configured behind Nginx/Apache](../images/mobile-nginx-arch.png)

## Client

- **Applet** (`seafile-applet`): The GUI front-end
- **Seafile daemon** (``seafile``): data service daemon for client
- **Ccnet daemon** (``ccnet``): networking service daemon for client

