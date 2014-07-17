# Use existing ElasticSearch server
The search module use an elasticsearch server bundled within the seafile pro server tarball. However, you may have an existing Elasitcsearch server or cluster running in your company. In this situation, you can change the config file to use your existing ES server or cluster.

This feature is added since `Seafile Professional Server 2.0.5`.

## Notes

- Your ES cluster must have thrift transport plugin installed. If not, install it:

```
bin/plugin -install elasticsearch/elasticsearch-transport-thrift/1.6.0
```

Restart your ES server after this.

- Currently the seafile search module use the default analyzer in your ES server settings. 


## Change the config file

- Edit `pro-data/seafevents.conf`, add settings in the section **[INDEX FILES]** to specify your ES server host and port:

```
vim pro-data/seafevents.conf
```

```
[INDEX FILES]
...
es_host = 192.168.1.101
es_port = 9500
```

- `es_host`: The ip address of your ES server
- `es_port`: The listening port of the Thrift transport module. By default it should be `9500`
