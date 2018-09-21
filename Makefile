include $(THEOS)/makefiles/common.mk

ARCHS = arm64

TOOL_NAME = listext
listext_FILES = main.mm

include $(THEOS_MAKE_PATH)/tool.mk


run:
	./.theos/obj/debug/$(TOOL_NAME)