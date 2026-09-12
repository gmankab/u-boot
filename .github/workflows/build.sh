#!/usr/bin/env bash

set -uexo pipefail

dnf -y install bison flex gcc android-tools openssl-devel-engine gnutls-devel xxd
if [ $(uname -m) = x86_64 ]; then
  dnf -y install gcc-aarch64-linux-gnu
  export CROSS_COMPILE=aarch64-linux-gnu-
fi
make qcom_defconfig qcom-phone.config tauchgang.config $EXTRA_CONFIG
make -j$(nproc)
gzip -c u-boot-nodtb.bin > u-boot.gz
DTB_ARGS=''
if [ "$HEADER_VERSION" = 2 ]; then
  DTB_ARGS='--header_version=2 --dtb=u-boot.dtb'
else
  cat u-boot.dtb >> u-boot.gz
fi
mkbootimg --kernel=u-boot.gz $DTB_ARGS --base=0 --pagesize=$PAGE_SIZE --output=$IMAGE
