TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: container-build

# This is not used by docker targets, but if you use targets
# like "recipes/<package>", then you might have to adjust this.
include $(lastword $(wildcard ~/.config/emacs/elpa/package-build*))/package-build.mk
