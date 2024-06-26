#!/bin/bash
#
#

export maindir="$(pwd)"
export outside="${maindir}/.."
source "${outside}/environment/env"

pack() {
  if [ ! -d ${zipper} ]; then
    git clone https://github.com/${ANYKERNEL_REPO} -b ${ANYKERNEL_BRANCH} "${zipper}"
    cd "${zipper}" || exit 1
  else
    cd "${zipper}" || exit 1
    git reset --hard
    git checkout ${ANYKERNEL_BRANCH}
    git fetch origin ${ANYKERNEL_BRANCH}
    git reset --hard origin/${ANYKERNEL_BRANCH}
  fi

  cp -af "${out_dtb}" "${zipper}"
  # cp -af "${out_gz}" "${zipper}"
  # cp -af "${out_dtbo}" "${zipper}/dtbo.img"

  zip -r9 "$1" ./* -x .git README.md ./*placeholder
  cd "${maindir}"
}

# build
for toolchain in $1; do
  #rm -rf out
  bash -x "${outside}/environment/toolchains/${toolchain}.sh" setup

  BUILD_START=$(date +"%s")
  export CUR_TOOLCHAIN="${toolchain}"

  bash -x "${outside}/environment/toolchains/${toolchain}.sh" build ${defconfig}

  if [ -e "${out_dtb}" ]; then
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    pack ${zip_name}
    echo "build succeeded in $((DIFF / 60))m, $((DIFF % 60))s" > "${zip_name}.info"
    echo "md5: $(md5sum "${zip_name}" | cut -d' ' -f1)" >> "${zip_name}.info"
    echo "compiler: $(cat ${toolchain}.info)" >> "${zip_name}.info"
  else
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    echo "build failed in $((DIFF / 60))m, $((DIFF % 60))s" > "${toolchain}.log.info"
    echo "compiler: $(cat ${toolchain}.info)" >> "${toolchain}.log.info"
  fi
done