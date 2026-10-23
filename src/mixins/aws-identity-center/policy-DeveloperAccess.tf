# policy-DeveloperAccess.tf — custom SSO permission set mixin for aws-identity-center.
#
# A first-class CloudPosse "create your own mixin" artifact (see the
# aws-identity-center mixins/README "Pattern for Creating Your Own Mixins"):
# this file DEFINES the set as local.developer_access_permission_set but does
# NOT activate it. Activation is the one-line concat in the companion
# additional-permission-sets_override.tf mixin.
#
# Vendored into a consuming component via component.yaml `mixins:` at a pinned
# ref, so the stock aws-identity-center src/ tree stays pristine and this custom
# set carries its own provenance.
#
# DeveloperAccess — the blog's Hugo `hugo deploy` identity: CodeBuild + CodeCommit
# managed policies plus a CloudFront CreateInvalidation inline grant scoped to the
# therespondent-blog distribution. Attributes are a verbatim match of the live
# adopted set ps-fe6ac9984ccb481e (session_duration PT1H, no tags).
#
# Object shape matches cloudposse/sso/aws//modules/permission-sets @ 1.2.0.

locals {
  developer_access_permission_set = {
    name             = "DeveloperAccess"
    description      = "Developer access (CodeBuild/CodeCommit) - workload app accounts only, never a core-* or management."
    relay_state      = ""
    session_duration = "PT1H"
    tags             = {}
    # Verbatim match of the live DeveloperAccess inline policy (single
    # CreateInvalidation action, dist E2K77VK78BEUO5, 191084511797).
    inline_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "HugoDeployCloudFrontInvalidation"
          Effect   = "Allow"
          Action   = "cloudfront:CreateInvalidation"
          Resource = "arn:aws:cloudfront::191084511797:distribution/E2K77VK78BEUO5"
        },
      ]
    })
    policy_attachments = [
      "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess",
      "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser",
    ]
    customer_managed_policy_attachments = []
  }
}
