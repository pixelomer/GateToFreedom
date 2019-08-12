INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GateToFreedom
GateToFreedom_FRAMEWORKS = AVFoundation
GateToFreedom_FILES = Tweak.x $(wildcard GateToFreedom/*.m)
GateToFreedom_CFLAGS = -fobjc-arc -I. -include macros.h

include $(THEOS_MAKE_PATH)/tweak.mk
