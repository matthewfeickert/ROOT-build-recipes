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

The easiest way to check that a Python runtime has been built with the `--enable-shared` option is to check the value of `Py_ENABLE_SHARED` in the [`sysconfig`](https://docs.python.org/3/library/sysconfig.html) module

```shell
python -c "import sysconfig; assert sysconfig.get_config_var('Py_ENABLE_SHARED') == 1"
```

If this command runs without an `AssertionError` then `--enable-shared` was used during its build.

## ROOT build

Create a Python virtual environment for the build and install NumPy for ROOT to use

```shell
$ pyenv virtualenv 3.8.7 ROOT-build
(ROOT-build) $ python -m pip install --upgrade pip setuptools wheel
(ROOT-build) $ python -m pip install numpy
```

Then form the directory containing your clone of ROOT's Git repository run the build script.
This will checkout the release branch from ROOT and then configure and built but not install (so that validation checks can be performed).

```
(ROOT-build) $ bash build_ROOT.sh 2>&1 | tee root_build.log
```

After the build has finished (will probably take on the order of 40 minutes) without errors install it with

```
(ROOT-build) $ ROOT_VERSION="v6-22-02" cmake --build "root_build_${ROOT_VERSION}" --target install
```
