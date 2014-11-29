ML coding standards for Emily project

- Variable and package names are camelCased (contrary to normal OCaml standards). I could probably be talked into changing this.
- Tabs should be 4 spaces, no tab characters should appear in source. To ensure I don't accidentally mix in tabs, I install [the Checkfiles Extension](http://mercurial.selenic.com/wiki/CheckFilesExtension) for Mercurial and then I add this to my `.hg/hgrc`:

        [hooks]
        pretxncommit.checkfiles=hg checkfiles
        [checkfiles]
        checked_exts = .ml .em .py .pl

- There is a `make test`. It runs all the test cases listed in `sample/regression.txt`. `make && make test` should be run frequently (maybe eventually I'll make myself a precommit hook for that, too).

    Because `make test` is meant to catch and document *regressions*, nothing should ever be intentionally checked in if `make test` is failing. If a commit must be made while a test is failing, the test in question should be moved from `regression.txt` to `regression-known-bad.txt`. "Actually all tests" including the known bad ones can be tested with `make test-all`.

- Nothing critical to the build should ever depend on anything but OCaml, opam+opam modules or (because I guess I don't have an alternative) GNU make. (Note `make test` uses Python but it is not critical to the build.)