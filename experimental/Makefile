SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Avoid tabs
# brew install make --with-default-names
# brew install homebrew/dupes/make --with-default-names
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later. )
endif
 .RECIPEPREFIX = >

NO_COLOR    = \033[0m
INDENT      = -30s
BIGINDENT   = -50s
GREEN       = \033[36m
BLUE        = \033[34m
DIM         = \033[2m


SHELL = bash
# Default params
target ?= "staging"

install: # Installs the whole thing
	@echo "Installing.."
	@sleep 1
	@echo "Done."

deploy: # Deploys the app to given target [make deploy target=<staging>]
	@echo "Deploying to $(target).."
	@sleep 1
	@echo "Done. Successfully deployed to $(target)!"

print-logs:
	@echo "Logs.."
	@echo "Logs.."


# -----------------------------------------------------------
# CAUTION: If you have a file with the same name as make
# command, you need to add it to .PHONY below, otherwise it
# won't work. E.g. `make run` wouldn't work if you have
# `run` file in pwd.
.PHONY: help

# -----------------------------------------------------------
# -----       (Makefile helpers and decoration)      --------
# -----------------------------------------------------------

.DEFAULT_GOAL := help
# check https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
RESET = \033[0m
PRIMARY = \033[94;1m
DIM1 = \033[38;5;239;1m
DIM2 = \033[90;2m
TAB = 20 # Increase if you have long commands

help:
	@printf '$(DIM2)Available make commands:$(RESET)\n'
	@grep -E '^[a-zA-Z_-]+:.+#.+$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = "[: ]+#[ ]+"}; \
		{printf " $(DIM1)> make $(RESET)$(PRIMARY)%-$(TAB)s $(RESET)$(DIM2)# %s$(RESET)\n", \
			$$1, $$2}'
	@grep -E '^[a-zA-Z_-]+:$$' $(MAKEFILE_LIST) \
		| grep -v help \
		| awk 'BEGIN {FS = ":"}; \
		{printf " $(DIM1)> make $(RESET)$(PRIMARY)%-$(TAB)s$(RESET)\n", \
			$$1}'

