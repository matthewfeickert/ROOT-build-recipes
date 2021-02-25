#!/bin/bash

# bash "scrict mode"
set -e
set -u
set -o pipefail

ROOT_VERSION="v6-22-02"

pushd root || exit
git checkout "${ROOT_VERSION}" -b "${ROOT_VERSION}-branch"
popd || exit

# clean build
if [ -d "root_build_${ROOT_VERSION}" ]; then
    rm -rf "root_build_${ROOT_VERSION}"
fi

# c.f. https://root.cern/install/build_from_source/#all-build-options
cmake \
    -Dall=OFF \
    -Dsoversion=ON \
    -Dgsl_shared=ON \
    -DCMAKE_CXX_STANDARD=17 \
    -Dfortran=ON \
    -Droofit=ON \
    -Droostats=ON \
    -Dhistfactory=ON \
    -Dminuit2=ON \
    -Dbuiltin_xrootd=ON \
    -Dxrootd=ON \
    -Dpyroot=ON \
    -Dqtgsi=OFF \
    -Dcuda=OFF \
    -Dtmva-gpu=OFF \
    -Droot7=ON \
    -DPYTHON_EXECUTABLE="$(pyenv which python)" \
    -DCMAKE_INSTALL_PREFIX="${HOME}/bin/root" \
    -S root \
    -B "root_build_${ROOT_VERSION}"
cmake "root_build_${ROOT_VERSION}" -L
cmake --build "root_build_${ROOT_VERSION}" -- -j$(($(nproc) - 1))

# cmake --build "root_build_${ROOT_VERSION}" --target install

unset ROOT_VERSION
