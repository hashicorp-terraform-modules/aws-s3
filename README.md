# Terraform Module: Amazon S3 Bucket (aws-s3)

Terraform module to create/deploy AWS S3 buckets and related resources

* [Resources](#Resources)
* [Usage](#Usage)
* [Inputs](#Inputs)
* [Outputs](#Outputs)
* [Notes](#Notes)
* [To Do](#To-Do)
* [Additional Documentation](#Additional-Documentation)

## Resources

These types of resources are supported:

* [Amazon S3 Bucket Metrics](https://www.terraform.io/docs/providers/aws/r/s3_bucket_metric.html)
* [Amazon S3 Bucket Policy](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html)
* [Amazon S3 Bucket Public Access Block](https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html)
* [Amazon S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)

## Usage

```hcl
module "s3_bucket_example" {
  source = "git@github.com:hashicorp-terraform-modules/aws-s3.git?ref=v0.0.0"

  acl                           = public-read
  name                          = "s3-bucket-example"
  policy                        = templatefile("${path.module}/templates/s3-bucket-policy-example.json.tpl", { s3_bucket_name = "s3-bucket-example" })
  tags                          = merge({ Name: "s3-bucket-example" }, var.tags)
  versioning_enabled            = true
  versioning_mfa_delete_enabled = true
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

### Amazon S3 (bucket) Block Public Access (aws_s3_bucket_public_access_block)

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| block\_public\_acls | (Optional) Whether Amazon S3 should block public ACLs for this bucket. Defaults to true. Enabling this setting does not affect existing policies or ACLs. Block public access to buckets and objects granted through new access control lists (ACLs). S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs. | bool | true | no |
| block\_public\_policy | (Optional) Whether Amazon S3 should block public bucket policies for this bucket. Defaults to true. Enabling this setting does not affect the existing bucket policy. Block public access to buckets and objects granted through new public bucket policies. S3 will block new bucket policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources. | bool | true | no |
| ignore\_public\_acls | (Optional) Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to true. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. Block public access to buckets and objects granted through any access control lists (ACLs). S3 will ignore all ACLs that grant public access to buckets and objects. | bool | true | no |
| restrict\_public\_buckets | (Optional) Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to true. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. Block public and cross-account access to buckets and objects through any public bucket policies. S3 will ignore public and cross-account access for buckets with policies that grant public access to buckets and objects. | bool | true | no |

### Amazon S3 Bucket (aws_s3_bucket)

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | The canned ACL to apply to the bucket. e.g. private, public-read, bucket-owner-read, etc. (default: private) | string | private | no |
| core\_rules | (Optional) List of maps containing a rule of Cross-Origin Resource Sharing. | set(any) | [] | no |
| lifecycle\_rules | (Optional) A list maps containing configurations for object lifecycle management. | set(any) | [] | no |
| logging\_bucket | (Optional) Enables server access logging when set to the name of an S3 bucket to receive the access logs. Use 'logging\_prefix' to specify a key prefix for log objects. | string | null | no |
| logging\_prefix | (Optional) Used with 'logging\_bucket' for server access logging to specify a key prefix for log objects. | string | null | no |
| name | (Optional, Forces new resource) The name of the bucket to create. If omitted, Terraform will assign a random, unique name. Conflicts with name\_prefix. | string | <generated> | no |
| name\_prefix | (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with name. | string | <generated> | no |
| policy | policy - (Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the Terraform AWS IAM Policy Document Guide. | string | N/A | no |
| region | (Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee. | string | N/A | no |
| tags | (Optional) A mapping of tags to assign the S3 bucket. (A Name tag is added based on name or name\_prefix) | map(string) | Name | no |
| sse\_kms\_id | (Optional) The ID of the KMS customer master key (CMK). Use 'aws/s3' for AWS managed CMK or the ARN of a Customer managed CMK. (default: aws/s3) | string | aws/s3 | no |
| sse\_type | (Optional) Enables/Disables server-side encryption (SSE). Valid values: 'amazon-s3' or 'aws-kms'. If not set, SSE is disabled. 'amazon-s3' (AES-256) enables Amazon S3 managed SSE. 'aws-kms' (AWS-KMS) enables SSE using AWS KMS. Use 'sse\_kms\_id' to choose which KMS CMK to use. (default: null i.e. disabled) | string | null | no |
| versioning\_enabled | (Optional) Whether or not to enable S3 bucket versioning. Once enabled, it can never return to an unversioned state. However, versioning can be suspended. (default: false) | bool | false | no |
| versioning\_mfa\_delete\_enabled | (Optional) Whether or not to enable S3 bucket versioning MFA deletion protection. Enable MFA protection for either changing the versioning state of the bucket or permanently deleting an object version. (default: false) | bool | false | no |

### Amazon S3 Bucket Metrics (aws_s3_bucket_metric)

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| metrics | (Optional) A list of filtering objects that accepts a prefix, set of tags or both. Unique identifier of the metrics configuration to create for the bucket. | set(any) | null | no |

Example:

   ```hcl
   metrics = [
     {
       name = "BigPdfsInDocs"
       prefix = "docs/"
       tags = {
         type = "pdf"
         size = "50"
       }
     },
     {
       name = "AllTemps"
       tags = {
         type = "temp"
       }
     },
     {
       name = "AnyPics"
       prefix = "pics/"
     }
   ]
   ```

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the bucket created |
| dns | The DNS domain name of the bucket created |
| name | The Name of the bucket created |
| region | The AWS region this bucket resides in |
| website\_endpoint | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string |
| website\_domain | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

1. This module uses Terraform version > 0.12.x
2. This module (current) does not add lifecycle rule(s) - WIP
3. This module (current) does not add server side encryption configuration - WIP

## To Do

* Figure out and add the dynamic configuration of server side encryption (with and without using a CMK)
* Figure out and add the dynamic configuration of lifecycle rule(s)

## Additional Documentation

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Working with Amazon S3 Buckets](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html)
