#!/bin/bash

TAR_NAME="AZQ_BOOT_SAMSUNG_GALAXY_S22_S901E_AVI7_$(date +%d%m%y).tar"

exit_if_failed() {
    if [[ $? -ne 0 ]]; then
	echo "Previous step failed"
	exit 1
    fi
}
echo "Build - kernel"
./build_kernel_GKI.sh
exit_if_failed

echo "Replace - kernel"
sudo cp out/msm-waipio-waipio-gki/dist/Image AIK-Linux/split_img/boot-magisk-avi7.img-kernel
exit_if_failed
echo "Repack - boot image"
./AIK-Linux/repackimg.sh > /dev/null 2>&1
exit_if_failed

echo "Copy - boot.img"
cp ./AIK-Linux/image-new.img boot.img
exit_if_failed
echo "Create - lz4"
lz4 -B6 -f --content-size boot.img boot.img.lz4
exit_if_failed
echo "Create - $(realpath ${TAR_NAME})"
tar -H ustar -cf ${TAR_NAME} boot.img.lz4
exit_if_failed
