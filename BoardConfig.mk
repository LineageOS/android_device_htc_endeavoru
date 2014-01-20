# Copyright 2010 The Android Open Source Project
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
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# inherit from tegra3-common
-include device/htc/tegra3-common/BoardConfigCommon.mk

# Boot/Recovery image settings
BOARD_KERNEL_CMDLINE :=
BOARD_KERNEL_PAGESIZE := 2048

TARGET_USERIMAGES_USE_EXT4 := true

# Partitions Info
#cat /proc/emmc
#dev:        size     erasesize name
#mmcblk0p5: 00800000 00001000 "recovery"
#mmcblk0p4: 00800000 00001000 "boot"
#mmcblk0p12: 50000000 00001000 "system"
#mmcblk0p13: 14000000 00001000 "cache"
#mmcblk0p17: 00200000 00001000 "misc"
#mmcblk0p1: 00600000 00001000 "wlan"
#mmcblk0p2: 00200000 00001000 "WDM"
#mmcblk0p20: 00200000 00001000 "pdata"
#mmcblk0p3: 00600000 00001000 "radiocab"
#mmcblk0p14: 650000000 00001000 "internalsd"
#mmcblk0p15: 89400000 00001000 "userdata"
#mmcblk0p19: 01600000 00001000 "devlog"
#mmcblk0p16: 00200000 00001000 "extra"

BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 8388608
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2302672896
BOARD_FLASH_BLOCK_SIZE := 4096

# Wifi related defines
USES_TI_MAC80211 := true

ifdef USES_TI_MAC80211
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X_TI
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
WIFI_FIRMWARE_LOADER             := ""
COMMON_GLOBAL_CFLAGS             += -DUSES_TI_MAC80211
endif

# Kernel
TARGET_KERNEL_SOURCE := kernel/htc/endeavoru
TARGET_KERNEL_CONFIG := cyanogenmod_endeavoru_defconfig

# Building wifi modules
BACKPORTS_DIR := "hardware/ti/wlan/mac80211/backports"
BACKPORTS_CONFIG := wl12xx

WIFI_MODULES:
	$(MAKE) -C $(BACKPORTS_DIR) mrproper
	$(MAKE) -C $(BACKPORTS_DIR) KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) \
		KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) defconfig-$(BACKPORTS_CONFIG)
	$(MAKE) -C $(BACKPORTS_DIR) KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) \
		KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE)

	mv $(BACKPORTS_DIR)/compat/compat.ko $(KERNEL_MODULES_OUT)
	mv $(BACKPORTS_DIR)/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
	mv $(BACKPORTS_DIR)/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
	mv $(BACKPORTS_DIR)/drivers/net/wireless/ti/wlcore/wlcore.ko $(KERNEL_MODULES_OUT)
	mv $(BACKPORTS_DIR)/drivers/net/wireless/ti/wlcore/wlcore_sdio.ko $(KERNEL_MODULES_OUT)
	mv $(BACKPORTS_DIR)/drivers/net/wireless/ti/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)

	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/cfg80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/compat.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/mac80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wlcore.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wlcore_sdio.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx.ko

TARGET_KERNEL_MODULES := WIFI_MODULES

# Avoid the generation of ldrcc instructions
NEED_WORKAROUND_CORTEX_A9_745320 := true

# Sensors invensense
BOARD_USES_GENERIC_INVENSENSE := false

# Bluetooth
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/htc/endeavoru/bluetooth

# Recovery
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_RECOVERY_SWIPE := true
TARGET_RECOVERY_FSTAB := device/htc/endeavoru/ramdisk/fstab.endeavoru
RECOVERY_FSTAB_VERSION := 2
BOARD_HAS_LARGE_FILESYSTEM := true

# UMS
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/f_mass_storage/lun0/file"

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/htc/endeavoru

# Device specific SELinux policies
BOARD_SEPOLICY_DIRS += \
    device/htc/endeavoru/selinux

#BOARD_SEPOLICY_UNION +=
