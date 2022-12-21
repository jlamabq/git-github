

resource "aws_ssm_parameter" "application_encryption" {
  count = length(var.application_encryption)
  name        = "/${var.project}/encryption/${keys(var.application_encryption)[count.index]}"
  description = "${var.project} application encryption key"
  type        = "SecureString"
  value       = values(var.application_encryption)[count.index]
  overwrite   = "true"

  tags = merge(local.module_tags_list,
      {
        "abq:name" = "/${var.project}/encryption/${keys(var.application_encryption)[count.index]}",
      })
}

#echo -n `openssl rand -base64 44`| xargs echo -n | base64
########################### JWT_SIGNING_KEY ###########################
resource "aws_ssm_parameter" "JWT_SIGNING_KEY" {

  name        = "/${var.project}/encryption/JWT_SIGNING_KEY"
  key_id      = "alias/aws/ssm"
  description = "${var.project} JTW signing key"
  type        = "SecureString"
  overwrite   = "true"
  value       = "QkJwczNXeEhwNWkzeUQ3ZDhJRUF1cHY3WlB4aklGUWcrdXFwSkpmVFpLK3pNMmxFd1Q5MWR4OUdoL3M9"
  ##value     = "Rbrnd71HSo6zn3er4BQRE6JcixKYTF+B20yDuyWfn0L95C14LvPSY+u9Ix5UuUil/suhidyr4NFjx83J"


  tags = merge(local.module_tags_list,
      {
        "abq:name" = "${var.project}-${var.region}-JWT_SIGNING_KEY",
      })
}

