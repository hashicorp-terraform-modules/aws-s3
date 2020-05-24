# Locals
# ---------
locals {
  amazon_s3 = "amazon-s3"
  aws_kms   = "aws-kms"
}


# Resources
# ---------

# Amazon S3 Block Public Access (bucket)
# --------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  depends_on              = [aws_s3_bucket_policy.this]
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  bucket                  = aws_s3_bucket.this.id
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


# Amazon S3 Bucket
# ----------------
resource "aws_s3_bucket" "this" {
  acl           = var.acl
  bucket        = var.name
  bucket_prefix = var.name_prefix
  policy        = var.policy
  region        = var.region
  tags          = merge({ Name : coalesce(var.name, var.name_prefix, "terraform-assigned") }, var.tags)
  versioning {
    enabled    = var.versioning_enabled
    mfa_delete = var.versioning_mfa_delete_enabled
  }

  dynamic "cors_rule" {
    for_each = length(var.cors_rules) == 0 ? [] : [var.cors_rules]
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules == null ? [] : var.lifecycle_rules
    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "tags", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                                = lifecycle_rule.value.enabled
      dynamic "expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }
      dynamic "transition" {
        for_each = lookup(lifecycle_rule.value, "transition", [])
        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]
        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])
        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging_bucket == null ? [] : list(var.logging_bucket)

    content {
      target_bucket = logging.value
      target_prefix = var.logging_prefix
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.sse_type == null ? [] : list(var.sse_type)
    iterator = sse_type
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = lower(sse_type.value) == local.amazon_s3 ? null : lower(sse_type.value) == local.aws_kms ? var.sse_kms_id : null
          sse_algorithm     = lower(sse_type.value) == local.amazon_s3 ? "AES256" : lower(sse_type.value) == local.aws_kms ? "aws:kms" : null
        }
      }
    }
  }
}


# Amazon S3 Bucket Policy
# -----------------------
resource "aws_s3_bucket_policy" "this" {
  count  = var.policy == null ? 0 : 1
  bucket = aws_s3_bucket.this.id
  policy = var.policy
}


# Amazon S3 Bucket Metrics
# ------------------------
resource "aws_s3_bucket_metric" "this" {
  for_each = var.metrics == null ? [] : var.metrics

  bucket = aws_s3_bucket.this.id
  name   = lookup(each.value, "name")
  filter {
    prefix = lookup(each.value, "prefix", null)
    tags   = lookup(each.value, "tags", null)
  }
}
