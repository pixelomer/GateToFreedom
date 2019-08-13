INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:11.2:11.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GateToFreedom
GateToFreedom_FRAMEWORKS = AVFoundation
GateToFreedom_FILES = Tweak.x $(wildcard GateToFreedom/*.m)
GateToFreedom_CFLAGS = -fobjc-arc -I. -include macros.h -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
