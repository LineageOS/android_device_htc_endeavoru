#
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

DEVICE_PACKAGE_OVERLAYS += device/htc/endeavoru/overlay

# Set default USB interface
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mass_storage,adb

# Don't store dalvik on /cache, it gets annoying when /cache is wiped
# by us to enable booting into recovery after flashing boot.img
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-data-only=1

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Init files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ramdisk/fstab.endeavoru:root/fstab.endeavoru \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.rc:root/init.endeavoru.rc \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.usb.rc:root/init.endeavoru.usb.rc \
    $(LOCAL_PATH)/ramdisk/init.rc:root/init.rc \
    $(LOCAL_PATH)/ramdisk/ueventd.endeavoru.rc:root/ueventd.endeavoru.rc

PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml)

# bluetooth config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.conf:system/etc/bluetooth/main.conf

# bluetooth LE hardware feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# configs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:system/etc/gps.conf

# nfc
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/nfcee_access.xml:system/etc/nfcee_access.xml

# Other extra packages
PRODUCT_PACKAGES += \
    librs_jni

# Bluetooth tools
PRODUCT_PACKAGES += \
    l2ping \
    hciconfig \
    hcitool \
    libbt-vendor

# audio packages
PRODUCT_PACKAGES += \
    tinymix \
    tinyplay \
    tinycap

# Wi-Fi
PRODUCT_COPY_FILES += $(LOCAL_PATH)/prebuilt/bin/wifi_calibration.sh:system/bin/wifi_calibration.sh
PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf \
    wifical.sh \
    TQS_D_1.7.ini \
    calibrator \
    crda \
    regulatory.bin \
    wlconf

$(call inherit-product, vendor/htc/endeavoru/endeavoru-vendor.mk)

# common tegra3-HOX+ configs
$(call inherit-product, device/htc/tegra3-common/tegra3.mk)
