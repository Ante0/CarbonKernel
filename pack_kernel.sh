#!/bin/bash
VERS="$(make kernelversion)"
rm AnyKernel2/Image.gz-dtb
cp out/arch/arm64/boot/Image.gz-dtb releases/Image_$VERS.gz-dtb
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel2/Image.gz-dtb
cd AnyKernel2/
zip -r ../releases/CarbonKernel_$VERS.zip *
echo "Image.gz-dtb copied to releases/Image_$VERS.gz-dtb"
echo "Flashable kernel copied to releases/CarbonKernel_$VERS.zip"
