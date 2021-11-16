# Repro

```
cabal repl
cabal repl
```

```
[nix-shell:~/packman]$ cabal repl
Resolving dependencies...
Build profile: -w ghc-8.10.2 -O1
In order, the following will be built (use -v for more details):
 - packman-0.5.0 (lib) (first run)
Configuring library for packman-0.5.0..
Preprocessing library for packman-0.5.0..
GHCi, version 8.10.2: https://www.haskell.org/ghc/  :? for help
[1 of 4] Compiling GHC.Packing.PackException ( /home/matt/packman/dist-newstyle/build/x86_64-linux/ghc-8.10.2/packman-0.5.0/build/GHC/Packing/PackException.hs, /run/user/1000/ghc1380672_0/ghc_8.o )
[2 of 4] Compiling GHC.Packing.Type ( GHC/Packing/Type.hs, /run/user/1000/ghc1380672_0/ghc_10.o )
[3 of 4] Compiling GHC.Packing.Core ( GHC/Packing/Core.hs, /run/user/1000/ghc1380672_0/ghc_6.o )
[4 of 4] Compiling GHC.Packing      ( GHC/Packing.hs, interpreted )
Ok, four modules loaded.
*GHC.Packing> :q
Leaving GHCi.
^[[A
[nix-shell:~/packman]$ cabal repl
Build profile: -w ghc-8.10.2 -O1
In order, the following will be built (use -v for more details):
 - packman-0.5.0 (lib) (first run)
Preprocessing library for packman-0.5.0..
GHCi, version 8.10.2: https://www.haskell.org/ghc/  :? for help
/nix/store/p792j5f44l3f0xi7ai5jllwnxqwnka88-binutils-2.31.1/bin/ld.gold: error: /home/matt/packman/dist-newstyle/build/x86_64-linux/ghc-8.10.2/packman-0.5.0/build/cbits/Wrapper.o: requires dynamic R_X86_64_PC32 reloc against 'g0' which may overflow at runtime; recompile with -fPIC
collect2: error: ld returned 1 exit status
`cc' failed in phase `Linker'. (Exit code: 1)
cabal: repl failed for packman-0.5.0.
```


