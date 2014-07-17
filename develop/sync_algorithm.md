# Synchronization algorithm

This article tries to give an overview on Seafile's file synchronization algorithm.
For clarity, some details are deliberately omitted, but it should help you get the
big picture.

To better understand this article, you should first read [[Seafile data model]].

## The Basic Work Flow

Each downloaded repo is bound to an ordinary local folder. Using Git's terminology,
we call this local folder the "worktree".

A typical synchronization work flow consists of the following steps:

1. Seafile client daemon detects changes in the worktree (via inotify etc).
2. The daemon commits the changes to the `local` branch.
3. Download new changes from the `master` branch on the server (if any).
4. Merge the downloaded branch into `local` branch (also checkout changes to worktree).
5. Fast-forward upload `local` branch to server's `master` branch.

Since the above work flow may be interrupted at any point by shutting down the
program or computer, after reboot we lose all notifications from the OS.
We need a reliable and efficient way to determine which
files in the worktree has been changed (even after reboots).

We use Git's index file to do this. It caches the timestamps of every
file in the worktree when the last commit is generated. So we can easily and
reliably detect changed files in the worktree since the latest commit
by comparing timestamps.

Another notable case is what happens if two clients try to upload to the server
simultaneously. The commit procedure on the server ensures atomicity. So only
one client will update the `master` branch successfully, while the other will
fail.

The failing client will restart the sync work flow later. It will first merge
the changes from the succeeded client then upload again.

## Merge

The most tricky part of the syncing algorithm is merging.

Git's merge algorithm doesn't work well enough for auto synchronization.

Firstly, if a merge is interrupted, git requires you to reset to the latest commit and
merge again. It's not a problem for Git since it's a single command.
But seafile runs as a daemon and may be kill at any time.
The user may have changed some files in the worktree between the interruption
and restart. Resetting the worktree will LOSE user's uncommitted data.

Secondly, Git's merge command will fail if it fails to update a file in the worktree.
But on Windows, an opened Office document will be write-protected by the
Office process. So the merge may fail in this case.

That's why programs use Git directly for auto-sync is not reliable.

Seafile implement its own merge algorithm based on the ideas from Git's
merge algorithm.

It handles the first problem by "redoing" the merge carefully after restart.
It handles the second problem by not starting merge until no file is
write-protected in the worktree.

Seafile's merge algorithm also handles all the conflict cases handled by Git.

