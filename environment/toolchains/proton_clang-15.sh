#!/bin/bash

maindir="$(pwd)"
outside="${maindir}/.."

# put this in clang version
dir="${outside}/proton-clang-master"

case $1 in
  "setup" )
    # Clone compiler
    if [[ ! -d "${dir}" ]]; then
	  curl -Lo a.tar.gz "https://gitlab.com/LeCmnGend/clang/-/archive/clang-15/clang-clang-15.tar.gz"
	  tar -zxf a.tar.gz
    fi
  ;;

  "build" )
    export PATH="${dir}/bin:/usr/bin:${PATH}"
    make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
    make -j$(nproc --all) O=out \
      CROSS_COMPILE="aarch64-linux-gnu-" \
      CROSS_COMPILE_ARM32="arm-linux-gnueabi-" \
      CC="clang" \
      LLVM=1 \
      2>&1 | tee ${CUR_TOOLCHAIN}.log
    sh ${outside}/environment/toolchain_version.sh clang ld.lld > ${CUR_TOOLCHAIN}.info
  ;;
esac
