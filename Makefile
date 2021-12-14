# Sane defaults
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
# Default params
# environment ?= "dev"

# ---------------------- COMMANDS ---------------------------

dev: # Kick-off local dev environment & start coding! 💻
	@echo "Starting dev env (e.g. npm start).."
	@sleep 1000

setup: # Setup local dev environment
	@echo "Installing.."
	@sleep 1
	@echo "Done."

purge: check-confirm # Clean up all local dev artifacts (node_modules, etc.)
	@echo "Purging.."
	@sleep 1
	@echo "Done."

pr: # Create a GitHub Pull Request via https://cli.github.com/
	@gh pr create

script: # Run .sh script and pass parameters
	@./script.sh $(args)

push: arg-target check-dotenv
	@echo "Deploying to $(target).."
	@sleep 1
	@echo "Done. Successfully deployed to $(target)!"

db.init: # Initialize DB for development
	@echo "DB initialized."

db.migrate: env-MYSQL_HOST # Run DB migrations
	@echo "DB migrated."

deploy: arg-target check-dotenv # E.g. make deploy target=production
	@echo "Deploying to $(target).."
	@sleep 1
	@echo "Done. Successfully deployed to $(target)!"

logs:
	tail -f *.log

# ----------------- COMMON CHECKS  --------------------------

env-MYSQL_HOST: # [CHECK] Checks for env variable
	@if test -z ${MYSQL_HOST}; then echo -e "${ERR}Missing ENV VAR: MYSQL_HOST. Use 'ENV_VAR=value make <cmd>'${NC}"; exit 1; fi

arg-target: # [CHECK] Checks if param is present: make key=value
	@if [ "$(target)" = "" ]; then echo -e "${ERR}Missing param: target. Use 'make <cmd> arg=value'${NC}"; exit 1; fi

check-confirm: # Simple y/N confirmation
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ] || (echo "Aborted!" && exit 1)

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
ERR = \033[31;1m
TAB := '%-20s' # Increase if you have long commands

# tput colors
red := $(shell tput setaf 1)
green := $(shell tput setaf 2)
yellow := $(shell tput setaf 3)
blue := $(shell tput setaf 4)
cyan := $(shell tput setaf 6)
cyan80 := $(shell tput setaf 86)
grey500 := $(shell tput setaf 244)
grey300 := $(shell tput setaf 240)
bold := $(shell tput bold)
underline := $(shell tput smul)
reset := $(shell tput sgr0)

help:
	@printf '\n'
	@printf '    $(underline)$(grey500)Available make commands:$(reset)\n\n'
	@# Print non-check commands with comments
	@grep -E '^([a-zA-Z0-9_-]+\.?)+:.+#.+$$' $(MAKEFILE_LIST) \
		| grep -v '^check-' \
		| grep -v '^env-' \
		| grep -v '^arg-' \
		| sed 's/:.*#/: #/g' \
		| awk 'BEGIN {FS = "[: ]+#[ ]+"}; \
		{printf " $(grey300)   make $(reset)$(cyan80)$(bold)$(TAB) $(reset)$(grey300)# %s$(reset)\n", \
			$$1, $$2}'
	@grep -E '^([a-zA-Z0-9_-]+\.?)+:( +\w+-\w+)*$$' $(MAKEFILE_LIST) \
		| grep -v help \
		| awk 'BEGIN {FS = ":"}; \
		{printf " $(grey300)   make $(reset)$(cyan80)$(bold)$(TAB)$(reset)\n", \
			$$1}'
	@echo -e "\n    $(underline)$(grey500)Helper/Checks$(reset)\n"
	@grep -E '^([a-zA-Z0-9_-]+\.?)+:.+#.+$$' $(MAKEFILE_LIST) \
		| grep -E '^(check|arg|env)-' \
		| awk 'BEGIN {FS = "[: ]+#[ ]+"}; \
		{printf " $(grey300)   make $(reset)$(grey500)$(TAB) $(reset)$(grey300)# %s$(reset)\n", \
			$$1, $$2}'
	@echo -e ""
