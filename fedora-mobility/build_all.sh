#!/bin/bash

set -uexo pipefail

build_uboot() {
  OUTNAME="$1"
  CONFIG="$2"
  DEVICETREE="$3"

  pushd ..
  make mrproper
  make $CONFIG
  make -j`nproc` DEVICE_TREE="$DEVICETREE"
  gzip u-boot-nodtb.bin -c > u-boot-nodtb.bin.gz
  cat u-boot-nodtb.bin.gz dts/upstream/src/arm64/$DEVICETREE.dtb > u-boot-dtb
  mkbootimg --kernel_offset '0x00008000' --pagesize '4096' --kernel u-boot-dtb -o u-boot.img
  mkdir -p fedora-mobility/output/
  cp u-boot.img fedora-mobility/output/"$OUTNAME"
  popd
}

build_uboot uboot-sdm845-oneplus-enchilada.img "qcom_defconfig fastboot-debug.config qcom-phone.config" qcom/sdm845-oneplus-enchilada
build_uboot uboot-sdm845-oneplus-fajita.img "qcom_defconfig fastboot-debug.config qcom-phone.config" qcom/sdm845-oneplus-fajita
build_uboot uboot-sdm845-xiaomi-beryllium-tianma.img "qcom_defconfig fastboot-debug.config qcom-phone.config" qcom/sdm845-xiaomi-beryllium-tianma
build_uboot uboot-sdm845-xiaomi-beryllium-ebbg.img "qcom_defconfig fastboot-debug.config qcom-phone.config" qcom/sdm845-xiaomi-beryllium-ebbg

