#!/bin/bash

# Copyright (C) 2024 psionicprjkt

compile_kernel() {
    # compile_kernel
    export ARCH=arm64
    make O=out ARCH=arm64 mido_defconfig

    # Generate profile data during the first compilation
    PATH="${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}" \
    make -j$(nproc --all) O=out \
        ARCH=arm64 \
        CC="clang" \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE="${PWD}/clang/bin/aarch64-linux-gnu-" \
        CROSS_COMPILE_ARM32="${PWD}/clang/bin/arm-linux-gnueabi-" \
        CONFIG_NO_ERROR_ON_MISMATCH=y \
        CFLAGS="-Wno-pragma-messages"
}

setup_kernel_release() {
    # setup_kernel_release
    v=$(cat version)
    d=$(date "+%d%m%Y")
    z="psionic-kernel-mido-$d-$v-ksu.zip"
    wget --quiet https://psionicprjkt.my.id/assets/files/AK3-mido.zip && unzip AK3-mido
    cp out/arch/arm64/boot/Image.gz-dtb AnyKernel && cd AnyKernel
    zip -r9 "$z" *
}

compile_kernel
setup_kernel_release
