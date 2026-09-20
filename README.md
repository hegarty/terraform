# terraform
Collection of generic Terraform resources

## Module versioning

Every module in this repo is released independently, tagged as
`<module-path>/vMAJOR.MINOR.PATCH` (e.g. `eks/karpenter/v1.0.0`,
`rds-postgres/v1.2.0`). Terragrunt consumers pin an exact tag — never `?ref=main` — so
upgrading one module never implies upgrading any other.

```
make release MODULE=eks/karpenter VERSION=1.0.0
```

This validates the module (`terraform fmt -check`, `terraform init -backend=false`,
`terraform validate`), refuses if the tag already exists or the module has uncommitted
changes, then **prints** the exact `git tag` / `git push` commands and asks for
confirmation before running them. It never tags or pushes silently.

Breaking changes bump MAJOR; anything additive/backward-compatible bumps MINOR or PATCH.
Every module not yet tagged as of this convention's introduction is being bootstrapped at
`v1.0.0` to mark "this is what's live today" — see the release plan/commands in the
accompanying PR before any tag is actually pushed. Full rationale and the Terragrunt-side
reference pattern: `shop_docs/docs/terraform-versioning.md` (once that repo exists).

`make validate-all` runs `fmt -check` + `validate` across every module directory in the
repo — useful before a bulk release or as a local pre-commit check.
