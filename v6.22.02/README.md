# ROOT v6.22.02

## pyenv build configuration

To get ROOT to build nicely and not get through the full build and then error at the end with something like

```
[100%] Linking CXX shared library ../../lib/libHistFactory.so
[100%] Built target HistFactory
Scanning dependencies of target hist2workspace
[100%] Building CXX object roofit/histfactory/CMakeFiles/hist2workspace.dir/src/hist2workspace.cxx.o
[100%] Building CXX object roofit/histfactory/CMakeFiles/hist2workspace.dir/src/MakeModelAndMeasurements.cxx.o
[100%] Linking CXX executable ../../bin/hist2workspace
[100%] Built target hist2workspace
/usr/bin/ld: /tmp/libPyMVA.so.6.22.02.DuVjqS.ltrans18.ltrans.o: in function `os_openpty.lto_priv.0':
/home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Modules/posixmodule.c:6683: undefined reference to `openpty'
/usr/bin/ld: /tmp/libPyMVA.so.6.22.02.DuVjqS.ltrans18.ltrans.o: in function `os_forkpty.lto_priv.0':
/home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Modules/posixmodule.c:6784: undefined reference to `forkpty'
/usr/bin/ld: /tmp/libPyMVA.so.6.22.02.DuVjqS.ltrans19.ltrans.o: in function `_PyImport_FindSharedFuncptr':
/home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Python/dynload_shlib.c:99: undefined reference to `dlopen'
/usr/bin/ld: /home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Python/dynload_shlib.c:130: undefined reference to `dlsym'
/usr/bin/ld: /home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Python/dynload_shlib.c:99: undefined reference to `dlopen'
/usr/bin/ld: /home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Python/dynload_shlib.c:105: undefined reference to `dlerror'
/usr/bin/ld: /home/feickert/build_src/root_build_v6-22-02/tmva/pymva/./Python/dynload_shlib.c:86: undefined reference to `dlsym'
collect2: error: ld returned 1 exit status
make[2]: *** [tmva/pymva/CMakeFiles/PyMVA.dir/build.make:169: lib/libPyMVA.so.6.22.02] Error 1
make[1]: *** [CMakeFiles/Makefile2:29693: tmva/pymva/CMakeFiles/PyMVA.dir/all] Error 2
make: *** [Makefile:152: all] Error 2
```

[CPython will need to be built with the `--enable-shared` flag](https://github.com/pyenv/pyenv/wiki#how-to-build-cpython-with---enable-shared).
This can be done with pyenv by using the `PYTHON_CONFIGURE_OPTS` environmental variable

```shell
PYTHON_CONFIGURE_OPTS="--with-ensurepip --enable-optimizations --with-lto --enable-loadable-sqlite-extensions --enable-ipv6 --enable-shared" \
    pyenv install 3.8.7
```
