shimit
======

Basic usage:

```
$ cabal configure
Resolving dependencies...
Configuring shimit-0.1.0.0...
$ cabal build
Building shimit-0.1.0.0...
Preprocessing executable 'shimit' for shimit-0.1.0.0...
[1 of 2] Compiling Testing.Shimit   ( Testing/Shimit.hs, dist/build/shimit/shimit-tmp/Testing/Shimit.o )
[2 of 2] Compiling Main             ( shimit.hs, dist/build/shimit/shimit-tmp/Main.o )
Linking dist/build/shimit/shimit ...
$ ./dist/build/shimit/shimit -i c/foo.c 
["c/bar.h","c/foo.h"]
```
