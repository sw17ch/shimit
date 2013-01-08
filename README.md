shimit
======

Basic usage:

```
$ cabal configure && cabal build
Resolving dependencies...
Configuring shimit-0.1.0.0...
Building shimit-0.1.0.0...
Preprocessing executable 'shimit' for shimit-0.1.0.0...
[1 of 2] Compiling Testing.Shimit   ( Testing/Shimit.hs, dist/build/shimit/shimit-tmp/Testing/Shimit.o )
[2 of 2] Compiling Main             ( shimit.hs, dist/build/shimit/shimit-tmp/Main.o )
Linking dist/build/shimit/shimit ...
$ ./dist/build/shimit/shimit -i c/foo.c
(NodeInfo ("c/bar.h": line 4) (("c/bar.h": line 4),1) Name {nameId = 4})
(NodeInfo ("c/bar.h": line 5) (("c/bar.h": line 5),1) Name {nameId = 10})
(NodeInfo ("c/foo.h": line 6) (("c/foo.h": line 6),1) Name {nameId = 18})
(NodeInfo ("c/foo.h": line 7) (("c/foo.h": line 7),1) Name {nameId = 25})
```
