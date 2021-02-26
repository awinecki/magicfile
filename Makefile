# Sane defaults
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
# Default params
# target ?= "staging"

# ---------------------- COMMANDS ---------------------------

dev: # Kick-off local dev environment & start coding! 💻
	@echo "Starting dev env (e.g. npm start).."
	@sleep 1000

setup: # Setup local dev environment
	@echo "Installing.."
	@sleep 1
	@echo "Done."

purge: # Clean up all local dev artifacts (node_modules, etc.)
	@echo "Purging.."
	@sleep 1
	@echo "Done."

pr: # Create a GitHub Pull Request via https://cli.github.com/
	@gh pr create

push: check-param check-dotenv
	@echo "Deploying to $(target).."
	@sleep 1
	@echo "Done. Successfully deployed to $(target)!"

db.init: # Initialize DB for development
	@echo "DB initialized."

db.migrate: # Run DB migrations
	@echo "DB migrated."

deploy: check-param check-dotenv # E.g. make deploy target=production
	@echo "Deploying to $(target).."
	@sleep 1
	@echo "Done. Successfully deployed to $(target)!"

logs:
	tail -f *.log

# ----------------- COMMON CHECKS  --------------------------

check-param: # [CHECK] Checks if param is present: make key=value
	@if [ "$(target)" = "" ]; then echo -e "${ERR}Missing param: target. Try: 'make cmd target=..'${NC}"; exit 1; fi

check-dotenv: # [CHECK] Checks if .env file is present
	@if [ ! -f ".env" ]; then echo -e "${ERR}Missing .env file. Run 'cp .env.example .env'${NC}"; exit 1; fi

check-node-modules: # [CHECK] Checks if /node_modules are present
	@if [ ! -d "node_modules" ]; then echo -e "${ERR}Missing /node_modules. Run npm / yarn install.${NC}"; exit 1; fi

check-env-vars: # [CHECK] Checks if env vars are present
	@if test -z ${AWS_ACCESS_KEY_ID}; then echo -e "${ERR}Missing env var: AWS_ACCESS_KEY_ID${NC}"; exit 1; fi
	@if test -z ${AWS_SECRET_ACCESS_KEY}; then echo -e "${ERR}Missing env var: AWS_SECRET_ACCESS_KEY${NC}"; exit 1; fi

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
NC = \033[0m
PRIMARY = \033[33;1m
SECONDARY = \033[94;1m
ERR = \033[31;1m
DIM1 = \033[38;5;239;1m
DIM2 = \033[90;2m
TAB = 20 # Increase if you have long commands

help:
	@printf '$(DIM2)Available make commands:$(NC)\n'
	@# Print non-check commands with comments
	@grep -E '^([a-zA-Z_-]+\.?)+:.+#.+$$' $(MAKEFILE_LIST) \
		| grep -v '^check-' \
		| sed 's/:.*#/: #/g' \
		| awk 'BEGIN {FS = "[: ]+#[ ]+"}; \
		{printf " $(DIM1)> make $(NC)$(PRIMARY)%-$(TAB)s $(NC)$(DIM2)# %s$(NC)\n", \
			$$1, $$2}'
	@# Print commands without comment only
	@grep -E '^([a-zA-Z_-]+\.?)+:( +\w+-\w+)*$$' $(MAKEFILE_LIST) \
		| grep -v help \
		| awk 'BEGIN {FS = ":"}; \
		{printf " $(DIM1)> make $(NC)$(PRIMARY)%-$(TAB)s$(NC)\n", \
			$$1}'
	@echo -e "${DIM1}-------- [checks] --------${NC}"
	@grep -E '^([a-zA-Z_-]+\.?)+:.+#.+$$' $(MAKEFILE_LIST) \
		| grep '^check-' \
		| awk 'BEGIN {FS = "[: ]+#[ ]+"}; \
		{printf " $(DIM1)> make $(NC)$(SECONDARY)%-$(TAB)s $(NC)$(DIM2)# %s$(NC)\n", \
			$$1, $$2}'
