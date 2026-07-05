TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
PACKAGE_BUILD_DIRECTORY ?= $(lastword $(wildcard ~/.config/emacs/elpa/package-build*))
ifeq ($(PACKAGE_BUILD_DIRECTORY),)
  PACKAGE_BUILD_DIRECTORY := $(TOP)/package-build
endif
PACKAGE_BUILD_MK := $(PACKAGE_BUILD_DIRECTORY)/package-build.mk

all: container-build

.PHONY: bootstrap-package-build missing-package-build

bootstrap-package-build:
	@test -d "$(PACKAGE_BUILD_DIRECTORY)" || \
	  git clone --depth 1 https://github.com/melpa/package-build.git "$(PACKAGE_BUILD_DIRECTORY)"

ifneq ($(wildcard $(PACKAGE_BUILD_MK)),)
include $(PACKAGE_BUILD_MK)
else
help container-image container-build build-channels build-channel page recipes/%: missing-package-build

missing-package-build:
	@echo "package-build was not found at $(PACKAGE_BUILD_DIRECTORY)."
	@echo "Run: make bootstrap-package-build"
	@echo "Then run: make container-image && make container-build"
	@exit 2
endif
