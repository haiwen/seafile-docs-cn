# Seafile GC

Seafile uses storage de-duplication technology to reduce storage usage.
Simply put, there would be two implications:

* Different versions of a file may share some data blocks;
* Different libraries may also share some data blocks.

The net result is that the underlying data blocks will not be removed
immediately after you delete a file library. As a result, the number of
unused data blocks will increase on Seafile server.

To release the storage space occupied by unused blocks, you have to run a
"garbage collection" program to clean up unused blocks on your server.

The GC program cleans up two types of unused blocks:

1. Blocks that no library references to;
2. If you set history length limit on some libraries, the out-dated blocks in those libraries will also be removed.

**Before running GC, you must shutdown the seafile program on your server.**
This is because new blocks written into Seafile while GC is running may be
mistakenly deleted by the GC program.

To run GC program

    cd seafile-server-{version}/seafile
    export LD_LIBRARY_PATH=./lib:${LD_LIBRARY_PATH}
    ./bin/seafserv-gc -c ../../ccnet -d ../../seafile-data

If you [[built seafile server from source|Build and deploy seafile server from source]],
just run

    seafserv-gc -c ../../ccnet -d ../../seafile-data

After the GC program terminates, you may also check whether it mistakenly removed any
useful data blocks:

    seafserv-gc -c ../../ccnet -d ../../seafile-data --verify

It will print a warning if any useful blocks are missing.

If you want to do sanity check before actually removing any data, you can use the --dry-run option

    seafserv-gc -c ../../ccnet -d ../../seafile-data --dry-run

It will show you the total block number vs. the number of blocks to be removed.

If the metadata of some libraries are damaged on the server, the GC program would stop proceeding because it can't tell whether a block is used by some damaged libraries or not. If you don't want to keep the data of the damaged library, you can run GC with --ignore-errors or -i option

    seafserv-gc -c ../../ccnet -d ../../seafile-data --ignore-errors

This will mask the blocks of the damaged libraries as unused and delete them.
