#!/bin/bash

# bash "strict mode"
set -e
set -u
set -o pipefail

ROOT_VERSION="v6-22-02"

pushd root_src || exit
git checkout "${ROOT_VERSION}" -b "${ROOT_VERSION}-branch"
popd || exit

# clean build
if [ -d "root_build_${ROOT_VERSION}" ]; then
    rm -rf "root_build_${ROOT_VERSION}"
fi

# c.f. https://root.cern/install/build_from_source/#all-build-options
INSTALL_PREFIX="${HOME}/bin/root-cern"
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
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -S root_src \
    -B "root_build_${ROOT_VERSION}"
cmake "root_build_${ROOT_VERSION}" -LH
cmake \
    --build "root_build_${ROOT_VERSION}" \
    --clean-first \
    --parallel "$(nproc --ignore=2)"

# cmake --install "root_build_${ROOT_VERSION}"

unset ROOT_VERSION
