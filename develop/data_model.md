# Data Model

Seafile internally uses a data model similar to GIT's. It consists of `Repo`, `Branch`, `Commit`, `FS`, and `Block`.

## Repo

A repo is also called a library. Every repo has an unique id (UUID), and attributes like description, creator, password.

## Branch

Unlike git, only two predefined branches is used, i.e., `local` and `master`.

In PC client, modifications will first be committed to the `local` branch.
Then the `master` branch is downloaded from server, and merged into `local` branch.
After that the `local` branch will be uploaded to server. Then the server will fast-forward
its `master` branch to the head commit of the just uploaded branch.

When users update a repo on the web, modifications will first be committed to temporary branch
on the server, then merged into the `master` branch.

## Commit

Like in GIT.

## FS

There are two types of FS objects, `SeafDir Object` and `Seafile Object`.
`SeafDir Object` represents a directory, and `Seafile Object` represents a file.

## Block

A file is further divided into blocks with variable lengths. We use Content Defined Chunking algorithm to
divide file into blocks. A clear overview of this algorithm can be found at http://pdos.csail.mit.edu/papers/lbfs:sosp01/lbfs.pdf.
On average, a block's size is around 1MB.

This mechanism makes it possible to deduplicate data between different versions of frequently updated files,
improving storage efficiency. It also enables transferring data to/from multiple servers in parallel.
