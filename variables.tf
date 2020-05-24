# Amazon S3 Block Public Access (bucket)
# (aws_s3_bucket_public_access_block)
# -----------------------------------
variable "block_public_acls" {
  default     = true
  description = "(Optional) Whether Amazon S3 should block public ACLs for this bucket. Defaults to true. Enabling this setting does not affect existing policies or ACLs. Block public access to buckets and objects granted through new access control lists (ACLs). S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs."
  type        = bool
}

variable "block_public_policy" {
  default     = true
  description = "(Optional) Whether Amazon S3 should block public bucket policies for this bucket. Defaults to true. Enabling this setting does not affect the existing bucket policy. Block public access to buckets and objects granted through new public bucket policies. S3 will block new bucket policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources."
  type        = bool
}

variable "ignore_public_acls" {
  default     = true
  description = "(Optional) Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to true. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. Block public access to buckets and objects granted through any access control lists (ACLs). S3 will ignore all ACLs that grant public access to buckets and objects."
  type        = bool
}

variable "restrict_public_buckets" {
  default     = true
  description = "(Optional) Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to true. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. Block public and cross-account access to buckets and objects through any public bucket policies. S3 will ignore public and cross-account access for buckets with policies that grant public access to buckets and objects."
  type        = bool
}


# Amazon S3 Bucket
# (aws_s3_bucket)
# ---------------
variable "acl" {
  default     = "private"
  description = "(Optional) The canned ACL to apply to the bucket. e.g. private, public-read, bucket-owner-read, etc. (default: private)"
  type        = string
}

variable "cors_rules" {
  default     = []
  description = "(Optional) List of maps containing a rule of Cross-Origin Resource Sharing."
  type        = set(any)
}

variable "lifecycle_rules" {
  default     = []
  description = "(Optional) A list maps containing configurations for object lifecycle management."
  type        = set(any)
}

variable "logging_bucket" {
  default     = null
  description = "(Optional) Enables server access logging when set to the name of an S3 bucket to receive the access logs. Use 'logging_prefix' to specify a key prefix for log objects."
  type        = string
}

variable "logging_prefix" {
  default     = null
  description = "(Optional) Used with 'logging_bucket' for server access logging to specify a key prefix for log objects."
  type        = string
}

variable "name" {
  default     = null
  description = "(Optional, Forces new resource) The name of the bucket to create. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
}

variable "name_prefix" {
  default     = null
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with name."
  type        = string
}

variable "policy" {
  default     = null
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the Terraform AWS IAM Policy Document Guide."
  type        = string
}

variable "region" {
  default     = null
  description = "(Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee."
  type        = string
}

variable "tags" {
  default     = null
  description = "(Optional) A mapping of tags to assign the S3 bucket. (A Name tag is added based on name or name_prefix)"
  type        = map(string)
}

variable "sse_kms_id" {
  default     = "aws/s3"
  description = "(Optional) The ID of the KMS customer master key (CMK). Use 'aws/s3' for AWS managed CMK or the ARN of a Customer managed CMK. (default: aws/s3)"
  type        = string
}

variable "sse_type" {
  default     = null
  description = "(Optional) Enables/Disables server-side encryption (SSE). Valid values: 'amazon-s3' or 'aws-kms'. If not set, SSE is disabled. 'amazon-s3' (AES-256) enables Amazon S3 managed SSE. 'aws-kms' (AWS-KMS) enables SSE using AWS KMS. Use 'sse_kms_id' to choose which KMS CMK to use. (default: null i.e. disabled)"
  type        = string
}

variable "versioning_enabled" {
  default     = false
  description = "(Optional) Whether or not to enable S3 bucket versioning. Once enabled, it can never return to an unversioned state. However, versioning can be suspended. (default: false)"
  type        = bool
}

variable "versioning_mfa_delete_enabled" {
  default     = false
  description = "(Optional) Whether or not to enable S3 bucket versioning MFA deletion protection. Enable MFA protection for either changing the versioning state of the bucket or permanently deleting an object version. (default: false)"
  type        = bool
}


# Amazon S3 Bucket Metrics
# (aws_s3_bucket_metric)
# ----------------------
variable "metrics" {
  default     = null
  description = "(Optional) A list of filtering objects that accepts a prefix, set of tags or both. Unique identifier of the metrics configuration to create for the bucket."
  type        = set(any)
}

# Example:
# metrics = [
#   {
#     name = "BigPdfsInDocs"
#     prefix = "docs/"
#     tags = {
#       type = "pdf"
#       size = "50"
#     }
#   },
#   {
#     name = "AllTemps"
#     tags = {
#       type = "temp"
#     }
#   },
#   {
#     name = "AnyPics"
#     prefix = "pics/"
#   }
# ]
