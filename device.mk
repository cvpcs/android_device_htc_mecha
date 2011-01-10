################# DEVICE SPECIFIC STUFF #####################
#
# Below are some things that make sure that the rom runs
# properly on htc mecha hardware
#

$(call inherit-product, device/common/gps/gps_us_supl.mk)

DEVICE_PACKAGE_OVERLAYS += device/htc/mecha/overlay

PRODUCT_PROPERTY_OVERRIDES += \
	ro.ril.oem.ecclist=112,911 \
	ro.ril.enable.a52=0 \
	ro.ril.enable.a53=1 \
	ro.build.changelist=313761 \
	ro.build.project=165253 \
	ro.product.version=1.03.605.10 \
	keyguard.no_require_sim=1 \
	ro.com.google.clientidbase=android-verizon \
	ro.com.google.gmsversion=2.2_r9 \
	media.a1026.nsForVoiceRec=0 \
	htc.audio.alt.enable=1 \
	htc.audio.hac.enable=1 \
	ro.setupwizard.enterprise_mode=1 \
	ro.media.codec_priority_for_thumb=so
# although these are in the leaked build.prop... no reason to set them as they're empty
#	ro.product.ua= \

# media config xml file
PRODUCT_COPY_FILES += \
        frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
        frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
        frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
        frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
        frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
        frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
        frameworks/base/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
        frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
        frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
        frameworks/base/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
        frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml \
        frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	device/htc/mecha/media_profiles.xml:system/etc/media_profiles.xml \
	device/htc/mecha/firmware/bcm4329.hcd:system/etc/firmware/bcm4329.hcd \
	device/htc/mecha/firmware/fw_bcm4329.bin:system/etc/firmware/fw_bcm4329.bin \
	device/htc/mecha/firmware/fw_bcm4329_apsta.bin:system/etc/firmware/fw_bcm4329_apsta.bin

PRODUCT_PACKAGES += \
	librs_jni

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Passion uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# include proprietaries
ifneq ($(USE_PROPRIETARIES),)
# if we aren't including google, we need to include some basic files
ifeq ($(filter google,$(USE_PROPRIETARIES)),)
PRODUCT_PACKAGES += \
        Provision \
        LatinIME \
        QuickSearchBox
endif

# actually include the props
$(foreach prop,$(USE_PROPRIETARIES), \
  $(if $(wildcard device/htc/mecha/proprietary.$(prop)), \
    $(eval \
PRODUCT_COPY_FILES += $(shell \
        cat device/htc/mecha/proprietary.$(prop) \
        | sed -r 's/^\/(.*\/)([^/ ]+)$$/device\/htc\/mecha\/proprietary\/\2:\1\2/' \
        | tr '\n' ' ') \
     ), \
    $(error Cannot include proprietaries from $(prop). List file device/htc/mecha/proprietary.$(prop) does not exist) \
   ) \
 )
endif
