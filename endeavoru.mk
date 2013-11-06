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

# Increase UMS speed
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vold.umsdirtyratio=50

# Enable legacy screenshot code for older Tegra 3 EGL libs
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bq.gpu_to_cpu_unsupported=1

# Override phone-xhdpi-1024-dalvik-heap.mk setting
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=96m

# Smoother window manager experience.
PRODUCT_PROPERTY_OVERRIDES += \
    windowsmgr.max_events_per_sec = 240 #300

# Old RIL features
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.ril.v3=signalstrength,skipbrokendatacall

# force gpu rendering(2d drawing) [Nvidia setting - libhtc-opt2.so]
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.ui.hw=true

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Prebuilt Sense 5 kernel modules
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/prebuilt/modules/baseband_usb_chr.ko:system/lib/modules/baseband_usb_chr.ko \
	$(LOCAL_PATH)/prebuilt/modules/baseband-xmm-power2.ko:system/lib/modules/baseband-xmm-power2.ko \
	$(LOCAL_PATH)/prebuilt/modules/bluetooth.ko:system/lib/modules/bluetooth.ko \
	$(LOCAL_PATH)/prebuilt/modules/bnep.ko:system/lib/modules/bnep.ko \
	$(LOCAL_PATH)/prebuilt/modules/btwilink.ko:system/lib/modules/btwilink.ko \
	$(LOCAL_PATH)/prebuilt/modules/cdc-acm.ko:system/lib/modules/cdc-acm.ko \
	$(LOCAL_PATH)/prebuilt/modules/cfg80211.ko:system/lib/modules/cfg80211.ko \
	$(LOCAL_PATH)/prebuilt/modules/compat.ko:system/lib/modules/compat.ko \
	$(LOCAL_PATH)/prebuilt/modules/fm_drv.ko:system/lib/modules/fm_drv.ko \
	$(LOCAL_PATH)/prebuilt/modules/gps_drv.ko:system/lib/modules/gps_drv.ko \
	$(LOCAL_PATH)/prebuilt/modules/hci_uart.ko:system/lib/modules/hci_uart.ko \
	$(LOCAL_PATH)/prebuilt/modules/hid-magicmouse.ko:system/lib/modules/hid-magicmouse.ko \
	$(LOCAL_PATH)/prebuilt/modules/hidp.ko:system/lib/modules/hidp.ko \
	$(LOCAL_PATH)/prebuilt/modules/kineto_gan.ko:system/lib/modules/kineto_gan.ko \
	$(LOCAL_PATH)/prebuilt/modules/lib80211.ko:system/lib/modules/lib80211.ko \
	$(LOCAL_PATH)/prebuilt/modules/mac80211.ko:system/lib/modules/mac80211.ko \
	$(LOCAL_PATH)/prebuilt/modules/raw_ip_net.ko:system/lib/modules/raw_ip_net.ko \
	$(LOCAL_PATH)/prebuilt/modules/rfcomm.ko:system/lib/modules/rfcomm.ko \
	$(LOCAL_PATH)/prebuilt/modules/scsi_wait_scan.ko:system/lib/modules/scsi_wait_scan.ko \
	$(LOCAL_PATH)/prebuilt/modules/st_drv.ko:system/lib/modules/st_drv.ko \
	$(LOCAL_PATH)/prebuilt/modules/tcrypt.ko:system/lib/modules/tcrypt.ko \
	$(LOCAL_PATH)/prebuilt/modules/ti_hci_drv.ko:system/lib/modules/ti_hci_drv.ko \
	$(LOCAL_PATH)/prebuilt/modules/wl12xx.ko:system/lib/modules/wl12xx.ko \
	$(LOCAL_PATH)/prebuilt/modules/wl12xx_sdio.ko:system/lib/modules/wl12xx_sdio.ko

# Init files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ramdisk/fstab.endeavoru:root/fstab.endeavoru \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.rc:root/init.endeavoru.rc \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.htc.rc:root/init.endeavoru.htc.rc \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.common.rc:root/init.endeavoru.common.rc \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.usb.rc:root/init.endeavoru.usb.rc \
    $(LOCAL_PATH)/ramdisk/init.endeavoru.cm.rc:root/init.endeavoru.cm.rc \
    $(LOCAL_PATH)/ramdisk/ueventd.endeavoru.rc:root/ueventd.endeavoru.rc

PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml)

# bluetooth config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.conf:system/etc/bluetooth/main.conf

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
