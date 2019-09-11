resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = "${aws_iam_role.transfer_server_role.arn}"

  tags {
    NAME = "${var.transfer_server_name}"
  }
}
