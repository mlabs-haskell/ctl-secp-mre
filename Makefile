.PHONY: build-nix hoogle nix-build-library nix-build-executables \
        nix-build-test nix-cabal-repl requires_nix_shell ci-build-run

# Generate TOC for README.md
# It has to be manually inserted into the README.md for now.
generate-readme-contents:
	nix shell nixpkgs#nodePackages.npm --command "npx markdown-toc ./README.md --no-firsth1"

# Starts a hoogle Server.
hoogle:
	@ nix develop -c hoogle server --local --port 8008

# Attempt the CI locally
# TODO

# Build the library with nix.
nix-build-library:
	@ nix build .#ctl-secp-mre:lib:ctl-secp-mre

current-system := $(shell nix eval --impure --expr builtins.currentSystem)

# Build the executables with nix (also builds the test suite).
nix-build-executables:
	@ nix build .#check.${current-system}

# Starts a ghci repl inside the nix environment.
nix-cabal-repl:
	@ nix develop -c cabal new-repl

# Target to use as dependency to fail if not inside nix-shell.
requires_nix_shell:
	@ [ "$(IN_NIX_SHELL)" ] || { \
	echo "The $(MAKECMDGOALS) target must be run from inside a nix shell"; \
	echo "    run 'nix develop' first"; \
	false; \
	}

FOURMOLU_EXTENSIONS := \
	-o -XTypeApplications \
	-o -XTemplateHaskell \
	-o -XImportQualifiedPost \
	-o -XPatternSynonyms \
	-o -fplugin=RecordDotPreprocessor

# Add folder locations to the list to be reformatted.
format:
	fourmolu $(FOURMOLU_EXTENSIONS) --mode inplace --check-idempotence \
		$(shell fd -ehs -elhs)

format_check:
	fourmolu $(FOURMOLU_EXTENSIONS) --mode check --check-idempotence \
		$(shell fd -ehs -elhs)

NIX_SOURCES := $(shell fd -enix)

nixpkgsfmt: requires_nix_shell
	nixpkgs-fmt $(NIX_SOURCES)

nixpkgsfmt_check: requires_nix_shell
	nixpkgs-fmt --check $(NIX_SOURCES)

lock: requires_nix_shell
	nix flake lock

lock_check: requires_nix_shell
	nix flake lock --no-update-lock-file

CABAL_SOURCES := $(shell fd -ecabal)

cabalfmt: requires_nix_shell
	cabal-fmt --inplace $(CABAL_SOURCES)

cabalfmt_check: requires_nix_shell
	cabal-fmt --check $(CABAL_SOURCES)

lint: requires_nix_shell
	hlint --no-summary $(shell fd -ehs -elhs)
