MODULE ?=
VERSION ?=

.PHONY: release
release:
	@if [ -z "$(MODULE)" ] || [ -z "$(VERSION)" ]; then \
		echo "Usage: make release MODULE=<path-under-repo-root> VERSION=<x.y.z>"; \
		echo "Example: make release MODULE=eks/karpenter VERSION=1.0.0"; \
		exit 1; \
	fi
	@if [ ! -d "$(MODULE)" ]; then \
		echo "No such module directory: $(MODULE)"; exit 1; \
	fi
	@echo "==> Validating $(MODULE)"
	@terraform -chdir="$(MODULE)" fmt -check -diff
	@terraform -chdir="$(MODULE)" init -backend=false -input=false >/dev/null
	@terraform -chdir="$(MODULE)" validate
	@rm -rf "$(MODULE)/.terraform" "$(MODULE)/.terraform.lock.hcl"
	@TAG="$(MODULE)/v$(VERSION)"; \
	if git rev-parse "$$TAG" >/dev/null 2>&1; then \
		echo "Tag $$TAG already exists. Bump VERSION or check you're releasing the right module."; \
		exit 1; \
	fi; \
	if ! git diff --quiet -- "$(MODULE)" || ! git diff --cached --quiet -- "$(MODULE)"; then \
		echo "$(MODULE) has uncommitted changes. Commit them before tagging a release."; \
		exit 1; \
	fi; \
	echo ""; \
	echo "About to run:"; \
	echo "  git tag -a $$TAG -m \"$(MODULE) v$(VERSION)\""; \
	echo "  git push origin $$TAG"; \
	echo ""; \
	read -p "Proceed? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		git tag -a "$$TAG" -m "$(MODULE) v$(VERSION)"; \
		git push origin "$$TAG"; \
		echo "Tagged and pushed $$TAG"; \
	else \
		echo "Aborted. No tag created."; \
	fi

.PHONY: validate-all
validate-all:
	@for dir in $$(find . -mindepth 1 -not -path './.git*' -name '*.tf' -exec dirname {} \; | sort -u); do \
		echo "==> $$dir"; \
		terraform -chdir="$$dir" fmt -check -diff || exit 1; \
		terraform -chdir="$$dir" init -backend=false -input=false >/dev/null || exit 1; \
		terraform -chdir="$$dir" validate || exit 1; \
		rm -rf "$$dir/.terraform" "$$dir/.terraform.lock.hcl"; \
	done
