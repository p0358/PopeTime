ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages
INSTALL_TARGET_PROCESSES = SpringBoard

include theos/makefiles/common.mk

TWEAK_NAME = PopeTime
PopeTime_FILES = Tweak.xm
PopeTime_FRAMEWORKS = UIKit
PopeTime_FRAMEWORKS += CoreGraphics
PopeTime_FRAMEWORKS += QuartzCore
PopeTime_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
