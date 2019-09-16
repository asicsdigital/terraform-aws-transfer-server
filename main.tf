resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = "${aws_iam_role.transfer_server_role.arn}"

  identity_provider_type = "${var.enable_password_auth ? "API_GATEWAY" : "SERVICE_MANAGED"}"
  invocation_role        = "${var.enable_password_auth ? aws_cloudformation_stack.password_auth.outputs["TransferIdentityProviderInvocationRole"] : ""}"


  tags {
    NAME = "${var.transfer_server_name}"
  }
}

resource "aws_cloudformation_stack" "password_auth" {
  count         = "${var.enable_password_auth ? 1 : 0}"
  name          = "${var.transfer_server_name}-password-auth"
  template_body = "${file("${path.module}/aws-transfer-custom-idp-secrets-manager-apig.template.yml")}"
  parameters    = {
    TransferServerName = "${var.transfer_server_name}"
  }
}
