#!/bin/bash

exit_if_failed() {
    if [[ $? -ne 0 ]]; then
	echo "Previous step failed!"
	exit 1
    fi
}

if [[ ! -d AIK-Linux ]]; then
    echo "Download - aik"
    scp test0.azenqos.com:/home/hasanbulat/tools/AIK-Linux-v3.8-ALL.tar.gz .
    exit_if_failed
    tar -xzf AIK-Linux-v3.8-ALL.tar.gz
    exit_if_failed
fi

if [[ ! -d kernel_platform/prebuilts ]]; then
    echo "Download - toolchain"
    scp test0.azenqos.com:/home/hasanbulat/tools/toolchain.tar.gz .
    exit_if_failed
    tar -xzf toolchain.tar.gz -C kernel_platform
    exit_if_failed
fi

if [[ ! -f bootimg/boot-magisk-avi7.img ]]; then
    echo "Decompress - boot"
    cd bootimg
    lz4 -d boot-magisk-avi7.img.lz4
    exit_if_failed
    cd ..
fi

if [[ ! -d AIK-Linux/split_img ]]; then
    echo "Unpack - boot"
    cd AIK-Linux
    sudo ./unpackimg.sh ../bootimg/boot-magisk-avi7.img > /dev/null 2>&1
    exit_if_failed
    cd ..
fi

echo "Ready to build"
