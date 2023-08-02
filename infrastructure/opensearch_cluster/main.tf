

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "logs_opensearch_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"]
  }
}

resource "aws_opensearch_domain" "logs_opensearch_domain" {
  domain_name    = var.domain_name
  engine_version = "OpenSearch_2.5"

  cluster_config {
    instance_type          = "t3.medium.search"
    zone_awareness_enabled = false
    instance_count = 1
  }

#   vpc_options {
#     subnet_ids = [
#       var.subnet_id
#     ]

#     security_group_ids = [var.sg_id]
#   }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = data.aws_iam_policy_document.logs_opensearch_policy.json

  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "opensrchuser"
      master_user_password = "Abc1234#"
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Domain = var.domain_name
  }
}