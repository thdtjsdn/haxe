# haXe

This git repository is a full copy of the [haXe svn repository](http://code.google.com/p/haxe/).
In addition this repository contains all dependencies required by the `install.ml` script.

**NOTE:** This is currently only tested with Ubuntu, but it should work with most Linux distributions
(and it could even work with OSX, but I am not able to test this).

## Prepare to compile

As usual you need a few libs installed on you system. (Ocaml and zLib) For Debian/Ubuntu systems:

```
sudo apt-get install ocaml camlp4 ocaml-findlib zlib1g-dev
```

(And of course git ;-)

More information are available [here](http://haxe.org/doc/build).

## Compile

```
ocaml install.ml
```

## Update

```
git pull
ocaml install.ml
```

## Install

There are currently no scripts to actually install haXe. You need to copy the binary (from `bin/` folder and 
the standard library from `std/` folder where ever you need them.)
I am also open for suggestions here ;-)

## Patches

There is currently no way to give patches back to the haXe compiler team from this repository. If you use this
to hack on the haXe compiler you need to create patches and send them to the [mailing list](https://groups.google.com/forum/#!forum/haxelang)
or as an attachment to Google code [issue tracker](http://code.google.com/p/haxe/issues/list).

If you need to know which svn revision belongs to a git commit take a closer look at the commit messages, there is some
metadata for every commit:

```
git-svn-id: http://haxe.googlecode.com/svn/trunk@$SVN_REVISION $GIT_COMMIT_HASH
```

## Scripts

There are few helper scripts in this repository:

* `install.ml` - Compile the haXe compiler. It is taken from the haXe website ([install.ml](http://haxe.org/file/install.ml))
and adjusted to work with this repository. (no download, paths are a little different.)
* `download_lib.sh` - Download the dependencies from the Motiontwin CVS server (Ocaml libs) and some of the neko source from
Google Code. (Requires svn and cvs)
* `tagging.sh` - Searches for tags on the svn trunk and creates missing git tags
* `remove_tags.sh` - In case the script above failed

## Setup a sync to SVN on your own

In case you want to sync your local clone by your self.  
This requires git-svn to be installed.

```
git svn init -s http://haxe.googlecode.com/svn
```

To make sure authors are mapped correctly edit your `.git/config` file and append (adjust the path to your git repository):

```
[svn]
		authorsfile = /path/to/haxe/git/repository/authors
```

First time sync (needs to be done once, takes up to one hour):

```
git svn fetch
```

Later syncs could triggered by:

```
git svn rebase
```

### Create git tags/branches from SVN tags/branches

Take a look at `tagging.sh`. Tags and (currently not existing) branches are mapped to `remotes/tags` and `remote/branches`, so in a nutshell:

Tags:

```
git tag -a "$GIT_TAG_NAME" "refs/remotes/tags/$SVN_TAG_NAME" -m "$TAG_MESSAGE"
```

Branches:

```
git branch $GIT_BRANCH_NAME "ref/remotes/branches/$SVN_BRANCH_NAME"
```
