project_name = test-http-ocaml

OPAM_EXEC = opam exec --
LOCALHOST = "http://localhost:8080"
DUNE = $(OPAM_EXEC) dune
opam_file = $(project_name).opam

.PHONY: help
help: ## Print this help message
	@echo "";
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}';
	@echo $(TEST_TARGETS) | tr -s " " "\012" | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m Run %s test \33[1;97m(or \"%s_watch\" to watch them)\033[0m\n", $$1, $$1, $$1}';
	@echo "";

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	$(DUNE) build --promote-install-files --root .

.PHONY: clean
clean: ## Clean artifacts
	$(DUNE) clean

.PHONY: deps
deps: $(opam_file) ## Alias to update the opam file and install the needed deps

.PHONY: format
fmt format: ## Formats code
	$(DUNE) build @fmt --auto-promote

.PHONY: create-switch
create-switch: ## Create opam switch
	opam switch create . 5.1.1 --deps-only --with-test --no-install

.PHONY: install
install: ## Install project dependencies
	opam install . --deps-only --with-test -y

.PHONY: init
init: create-switch install ## Create a local dev enviroment

.PHONY: serve
serve: ## Run the server
	$(DUNE) exec --no-print-directory test-http-ocaml.server

.PHONY: serve-watch
serve-watch: ## Run the server
	$(DUNE) exec -w --no-print-directory test-http-ocaml.server

# Testing commands

TEST_TARGETS := blink cohttp piaf

# Create targets with the format "test_{{target_name}} nad test_{{target_name}}_{{ "watch" }}"
define create_build
.PHONY: $(1)
build-$(1): ## Build $(1) tests
	$$(DUNE) build test_$(1)
endef

define create_build_watch
.PHONY: $(1)-watch
build-$(1)-watch: ## Build $(1) tests
	$$(DUNE) build test_$(1) --watch
endef

define create_run_test
.PHONY: run-$(1)
run-$(1): ## Build $(1) tests
	$$(DUNE) exec ./test_$(1).exe
endef

# Apply the create_watch_target rule for each test target
$(foreach target,$(TEST_TARGETS), $(eval $(call create_build,$(target))))
$(foreach target,$(TEST_TARGETS), $(eval $(call create_build_watch,$(target))))
$(foreach target,$(TEST_TARGETS), $(eval $(call create_run_test,$(target))))
