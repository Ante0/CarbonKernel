# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=CarbonKernel
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=OnePlus6T
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

# Save the users from themselves
android_version="$(file_getprop /system/build.prop "ro.build.version.release")";
supported_version=9;
if [ "$android_version" != "$supported_version" ]; then
  ui_print " "; ui_print "You are on $android_version but this kernel is only for $supported_version!";
  exit 1;
fi;

# If the kernel image and dtbs are separated in the zip
userflavor="$(grep "^ro.build.user" /system/build.prop | cut -d= -f2):$(grep "^ro.build.flavor" /system/build.prop | cut -d= -f2)";
case "$userflavor" in
  "OnePlus:OnePlus6T-user")
    os="oos";
    os_string="OxygenOS";;
  "OnePlus:OnePlus6-user")
    os="oos";
    os_string="OxygenOS";;
  "OnePlus:OnePlus6TSingle-user")
    os="oos";
    os_string="OxygenOS";;
  *)
    os="custom";
    os_string="a custom ROM";;
esac;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*; 


## AnyKernel install
dump_boot;


# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
  ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;  


# Clean up other kernels' ramdisk overlay files
#rm -rf $ramdisk/overlay;


# Add our ramdisk files if Magisk is installed
#if [ -d $ramdisk/.backup ]; then
#  mv /tmp/anykernel/overlay $ramdisk;
#fi

ui_print "-> $os_string detected";
if [ "$os_string" = "a custom ROM" ]; then
  patch_cmdline "is_custom_rom" "is_custom_rom";
fi;

# Install the boot image
write_boot;
