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

More information are available (here)[http://haxe.org/doc/build].

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
