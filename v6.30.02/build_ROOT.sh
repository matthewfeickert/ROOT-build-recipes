#!/bin/bash

# bash "strict mode"
set -e
set -u
set -o pipefail

ROOT_VERSION="v6-30-02"

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
    -DCMAKE_CXX_STANDARD=17 \
    -Droot7=ON \
    -Dfortran=ON \
    -Droofit=ON \
    -Droostats=ON \
    -Dhistfactory=ON \
    -Dminuit2=ON \
    -Dxrootd=ON \
    -Dbuiltin_xrootd=ON \
    -Dpyroot=ON \
    -Dqtgsi=OFF \
    -Dcuda=OFF \
    -Dtmva-gpu=OFF \
    -DPYTHON_EXECUTABLE="$(pyenv which python)" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -S root_src \
    -B "root_build_${ROOT_VERSION}"
cmake "root_build_${ROOT_VERSION}" -LH
cmake \
    --build "root_build_${ROOT_VERSION}" \
    --clean-first \
    --parallel "$(nproc --ignore=2)"

if [ -d "${INSTALL_PREFIX}" ]; then
    rm -rf "${INSTALL_PREFIX}"
fi
cmake --install "root_build_${ROOT_VERSION}"

unset ROOT_VERSION
