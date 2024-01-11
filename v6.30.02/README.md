# ROOT v6.30.02

## pyenv build configuration

To get ROOT to build nicely and not get through the full build and then error at the end with something like

[CPython will need to be built with the `--enable-shared` flag](https://github.com/pyenv/pyenv/wiki#how-to-build-cpython-with---enable-shared).
This can be done with pyenv by using the `PYTHON_CONFIGURE_OPTS` environmental variable

```shell
PYTHON_CONFIGURE_OPTS="--with-ensurepip --enable-optimizations --with-lto --enable-loadable-sqlite-extensions --enable-ipv6 --enable-shared" \
PYTHON_CFLAGS="-march=native -mtune=native" \
    pyenv install 3.11.7
```

The easiest way to check that a Python runtime has been built with the `--enable-shared` option is to check the value of `Py_ENABLE_SHARED` in the [`sysconfig`](https://docs.python.org/3/library/sysconfig.html) module

```shell
python -c "import sysconfig; assert sysconfig.get_config_var('Py_ENABLE_SHARED') == 1"
```

If this command runs without an `AssertionError` then `--enable-shared` was used during its build.

## ROOT build

Create a Python virtual environment for the build and install NumPy for ROOT to use

```shell
$ pyenv virtualenv 3.11.7 ROOT-build
(ROOT-build) $ python -m pip install --upgrade pip setuptools wheel
(ROOT-build) $ python -m pip install numpy
```

Then from the directory containing your clone of ROOT's Git repository run the build script.
This will checkout the release branch from ROOT and then configure, build, and install ROOT.

```
(ROOT-build) $ bash build_ROOT.sh 2>&1 | tee root_build.log
```
