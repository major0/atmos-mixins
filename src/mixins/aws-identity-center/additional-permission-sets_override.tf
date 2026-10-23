# additional-permission-sets_override.tf — ACTIVATION override (mixin-delivered).
#
# Terraform `_override.tf` merge: redefines the stock
# local.overridable_additional_permission_sets (default [] in the vended
# additional-permission-sets.tf) to activate our custom sets. The set DEFINITIONS
# live in their own policy-<Name>.tf mixins (e.g. policy-DeveloperAccess.tf);
# this file only concatenates them in — the CP "Activating Vendored Permission
# Sets" pattern.
#
# This override is itself vendored as a mixin (component.yaml `mixins:`), so the
# consuming component dir is fully reproducible from its manifest: stock src/ +
# pinned mixins, nothing hand-placed.
#
# Add a custom set by: (1) vendoring its policy-<Name>.tf mixin, (2) adding its
# local here.

locals {
  overridable_additional_permission_sets = [
    local.developer_access_permission_set,
  ]
}
