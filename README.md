# atmos-mixins

Reusable [Atmos mixin](https://atmos.tools/core-concepts/vendor/) files for
customizing vended CloudPosse components **without editing their pristine `src/`
trees**.

## Why this repo exists

The policy for our Atmos IaC is: **vend the stock upstream CloudPosse component
untouched, and express every local change only through CloudPosse's first-class
extension patterns** (mixins + `_override.tf` seams). This repo is the home for
those local extensions, so each one is a pinned, sourced, provenance-carrying
artifact — the same model CloudPosse uses for its own
[`mixins`](https://github.com/cloudposse-terraform-components/mixins) repo.

A consuming component's `component.yaml` vends the stock component, then pulls
the files it needs from here via `mixins:` at a tagged ref. The component
directory is then fully reproducible from its manifest: stock `src/` + pinned
mixins, nothing hand-placed.

## Layout

```
src/mixins/<component-name>/<file>.tf
```

One subdirectory per consuming component. Each custom permission set follows the
CloudPosse "create your own mixin" pattern: a `policy-<Name>.tf` file DEFINES the
set as a `local`, and a companion `*_override.tf` ACTIVATES it by concatenating
that local into the component's `overridable_*` seam.

### `aws-identity-center/`

| File | Role |
|------|------|
| `policy-DeveloperAccess.tf` | Defines `local.developer_access_permission_set` — the blog's Hugo deploy identity (CodeBuild + CodeCommit + CloudFront CreateInvalidation). |
| `additional-permission-sets_override.tf` | Activation override: concatenates the custom set(s) into `overridable_additional_permission_sets`. |

## Consuming a mixin

In the component's `component.yaml`:

```yaml
spec:
  source:
    uri: github.com/cloudposse-terraform-components/aws-identity-center.git//src?ref={{.Version}}
    version: v4.0.1
  mixins:
    - uri: https://raw.githubusercontent.com/major0/atmos-mixins/{{.Version}}/src/mixins/aws-identity-center/policy-DeveloperAccess.tf
      version: v0.1.0
      filename: policy-DeveloperAccess.tf
    - uri: https://raw.githubusercontent.com/major0/atmos-mixins/{{.Version}}/src/mixins/aws-identity-center/additional-permission-sets_override.tf
      version: v0.1.0
      filename: additional-permission-sets_override.tf
```

Then `atmos vendor pull -c <component>`.

## Versioning

Tag releases (`v0.1.0`, ...). Consumers pin a tag; bumps are deliberate and
reviewed via `git diff` of the vendored result.
