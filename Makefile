ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PopeTime
PopeTime_FILES = Tweak.xm
PopeTime_FRAMEWORKS = UIKit
PopeTime_FRAMEWORKS += CoreGraphics
PopeTime_FRAMEWORKS += QuartzCore
PopeTime_EXTRA_FRAMEWORKS += Cephei
PopeTime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += PopeTimePrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
