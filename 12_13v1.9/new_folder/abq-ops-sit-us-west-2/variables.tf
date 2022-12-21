#### AWS credentials profile from "~/.aws/credentials"
variable "profile" {
  default = "devops"
}

### Set client root ca name
variable "acm-pca-common-name" {
  default = "ClientGA1"
}

#### Set the project name (this must be globally unique)
variable "project" {
  default = "corn"
}

variable "default-identifier" {
  default = "corn"
}

variable "env-identifier" {
  default = "corn"
}

variable "release" {
  default = "v1.8.0"
}

#### Set region where the infrastructure will be deployed
# aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text
# https://docs.aws.amazon.com/general/latest/gr/rande.html

variable "region" {
  default = "us-west-2"
}

#### Set availability-zones used in the region
# aws ec2 describe-availability-zones --region us-west-2  --query "AvailabilityZones[].{Name:ZoneName}" --output text

variable "availability_zones" {
  default = {
    "zone-a"  = "us-west-2a",
    "zone-b"  = "us-west-2b",
    "zone-c"  = "us-west-2c"
  }
}

#### termination protection
variable "termination-protection" {
  default = "false"
}

variable "restriction_type" {
  default = "none"
}

variable "geo_restriction" {
  default = [] #open no geo_restriction
}

#### RDS DB
# openssl rand -base64 14 | sed 'y/\/+=/123/'
variable "user_accounts" {
  default = {
    "mysql-root"      = ["AQroot",    "64wv0DC8gMSTc44zXiQ3"],
    "mysql-hd-root"   = ["AQroot",    "HRoqOPg6R10PNVZNN5g3"],
    "redshift-root"   = ["aqroot",    "S3NpwtoEKDqvBgzoQSQ3"],
    "dms-mysql"       = ["AQroot",    "64wv0DC8gMSTc44zXiQ3"],
    "dms-mysql-hd"       = ["AQroot",    "HRoqOPg6R10PNVZNN5g3"],
    "dms-redshift-sm"    = ["vsms_corn_sm20","VSMS_corn_sm20"]
  }
}


#### Set availability-zones used in the region
# aws ec2 describe-availability-zones --region us-west-2  --query "AvailabilityZones[].{Name:ZoneName}" --output text


#### Set the desired /16 network
variable "network" {
  default = "10.35."
}

### Public AWS Zone
variable "aws-dnszone" {
  default = "corn.otamatic.io"
}

### Public ABQ Zone (mirror AWS Zone)
variable "abq-dnszone" {
  default = "aqcloud.io"
}

variable "aws-privatednszone" {
  default = "otamatic.io"
}


variable "self-certificate" {
  default =  {
    "arn"   = "",
    "body"  = "elb/self-certs/star.corn.otamatic.io_selfsigned.crt",
    "chain" = "elb/self-certs/star.corn.otamatic.io_selfsigned-CA.crt",
    "key"   = "elb/self-certs/star.corn.otamatic.io_selfsigned.key"
  }
}

#for aqcloud.io
variable "self-certificate-aqcloud" {
  default =  {
    "arn"   = "",
    "body"  = "elb/self-certs/star.aqcloud.io_selfsigned.crt",
    "chain" = "elb/self-certs/star.aqcloud.io_selfsigned-CA.crt",
    "key"   = "elb/self-certs/star.aqcloud.io_selfsigned.key"
  }
}

variable "pub-certificate" {
  default =  {
    "arn"   = "arn:aws:acm:us-west-2:551233250554:certificate/02721238-cc06-4911-8626-722d8aa05471",
    "body"  = "",
    "chain" = "",
    "key"   = ""
  }
}


# Certificate used for CloudFront distributions (us-east-1)
variable "sni-cert" {
  default = "arn:aws:acm:us-east-1:551233250554:certificate/6d59343a-ad98-41c0-96ff-dd3c76c16474"
  # default = "default"
}

#arn gets created by terraform later
variable "abq-pub-certificate" {
  default =  {
    "arn"   = "",
    "body"  = "../../aq-pbh-deployer/elb/AQCLOUD/STAR.AQCLOUD.IO.crt",
    "chain" = "../../aq-pbh-deployer/elb/AQCLOUD/ov_chain.crt",
    "key"   = "../../aq-pbh-deployer/elb/AQCLOUD/STAR.AQCLOUD.IO.key"
  }
}

# Private Certificate used for CloudFront distributions cdn-signed, cdn-unsigned, device-logs, and device-data (aqcloud.io)
variable "abq-private-sni-cert" {
  ### use public to start then use private on 2nd round to fix
  #TEMPORARY CERT
  #default = "arn:aws:acm:us-east-1:551233250554:certificate/73aa66f4-da78-417f-8649-a4d08f9969ee"
  #MAIN CERT FROM MOMEARA 
  default = "arn:aws:acm:us-east-1:551233250554:certificate/59d0ec50-9db1-48ad-ac0b-8dfcebcaba64"
}

# Public Certificate used for CloudFront distributions b2b-portal, and swupload (aqcloud.io)
variable "abq-public-sni-cert" {
  default = "arn:aws:acm:us-east-1:551233250554:certificate/73aa66f4-da78-417f-8649-a4d08f9969ee"
  # default = "default"
}

# echo -n 'MlNWKzU3cVU5OExnZnVHU0R3dU02NjM4UStLMU9ZaW9jWFp6OWQ0cnZ3UT0=' | base64
variable "application_encryption" {
  default = {
    "ENCRYPTION_KEY" = "TWxOV0t6VTNjVlU1T0V4blpuVkhVMFIzZFUwMk5qTTRVU3RMTVU5WmFXOWpXRnA2T1dRMGNuWjNVVDA9"
  }
}

### URLs to be associated with internet facing resources
locals {
   public_urls = {
    "b2b"                  = "${var.default-identifier}",
    "b2b-aqcloud"          = "${var.default-identifier}-b2b-portal",
    "gw-aqcloud"           = "${var.default-identifier}-gw-mob",
    "device-aqcloud"       = "${var.default-identifier}-device-api",
    "admin-aqcloud"        = "${var.default-identifier}-admin-api",
    "cdn-signed-aqcloud"   = "${var.default-identifier}-cdn-signed",
    "cdn-unsigned-aqcloud" = "${var.default-identifier}-cdn-unsigned",
    "swupload-aqcloud"     = "${var.default-identifier}-swupload",
    "device-logs-aqcloud"  = "${var.default-identifier}-device-logs",
    "device-data-aqcloud"  = "${var.default-identifier}-device-data",
    "b2b-sm"        = "${var.project}-${var.region}-b2b",
    "b2b-cdn"       = "${var.project}-${var.region}-b2b-portal",
    "gw-mob-sm"     = "${var.project}-${var.region}-gw-mob",
    "device-api-sm" = "${var.project}-${var.region}-device-api",
    "admin-api-sm"  = "${var.project}-${var.region}-admin-api",
    "cdn-signed"    = "${var.project}-${var.region}-cdn-signed",
    "cdn-unsigned"  = "${var.project}-${var.region}-cdn-unsigned",
    "swupload"      = "${var.project}-${var.region}-swupload",
    "device-logs"   = "${var.project}-${var.region}-device-logs",
    "device-data"   = "${var.project}-${var.region}-device-data",
    "ratelimit"     = "${var.project}-${var.region}-ratelimit",
    "oasis"         = "${var.project}-${var.region}-oasis"
  }
}

# Commands to generate the cdn public and private keys
# openssl genrsa -out private.pem 2048
# openssl rsa -pubout -in private.pem -out public.pem
variable "config_integration" {
  default = {
    "sms-api-gateway-endpoint"      = [""] # URL
    "transferable-resource"         = ["", "", false] # URL, target, vsms-listener
    "factory-feed-bucket"           = "corn-us-west-2-factory-feed",
    "ecu-keys-bucket"               = "corn-us-west-2-ecu-keys"
    "cdn-domain-swupload-unsigned-url"    = "",
    "cdn-domain-signed-url"               = "",
    "swupload-bucket"                     = "",
    "swrelease-bucket"                    = "",
    "campaign-messages-bucket"            = "",
    "cdn_signing_public_key"              = "cloudfront/public.pem",
    "cdn_signing_private_key"             = "cloudfront/private.pem"  }
}

# Deploy bundle-bundle transit gateway
# Does not deploy if values are empty
variable "transit-gateway" {
    default = {
      "id"      = [ "" ],
      "remote"  = [ "" ]
    }
}

# Deploy APIGW transit gateway
variable "transit-gateway-common" {
    default = {
      "id"      = [ "" ],    # Connect to TG-id, create TG if empty
      "remote"  = [ "" ]     # Peer VPC Network, do not create TG if empty
    }
}
# waf-enable = [enable-waf, enable-ipset, enable-oasp]
variable "waf_configuration" {
  default = {
    "waf-enable"          = [false],
    "ap-airbiquity"       = [],
    "ap-hoperun"          = [],
    "ap-tts"              = [],
    "ap-remoteworker"     = [],
    "cgmob-airbiquity"    = [],
    "cgmob-hoperun"       = [],
    "cgmob-tts"           = [],
    "cgmob-remoteworker"  = [],
  }
}

variable "instance_map" {
  default = {
  ########## Management Tier ##########
  "management-vm"   = ["t3.medium", "1"],

  ########## Web Tier ##########
  "web-vm"          = ["t3.large", "1"],
  "ap-vm"           = ["t3.medium", "0"],
  "cg-vm"           = ["t3.medium", "0"],
  "oasis-vm"        = ["t2.micro", "0"],

  ########## Application Tier ##########
  "application-sm-vm"  = ["t3.xlarge", "1"],
  "ud-vm"              = ["t3.medium", "0"],
  "bundle-vm"          = ["t3.large", "0"],
  "dr-vm"              = ["t3.large", "0"],
  "dc-vm"              = ["t3.medium", "0"],

  ########## Replication Tier ##########
  "replication-vm"    = ["t3.large", "1"],
  "dl-vm"             = ["t3.medium", "0"],

  ########## Messaging Tier ##########
  "messaging-vm"    = ["t3.large", "0"],
  "msk"             = ["kafka.t3.small", "3", "2.2.1"],

  ########## Database Tier ##########
  # ID,                TYPE,            COUNT, VERSION,                   INCREMENT, OFFSET, PORT,    MULTI-AZ
  "aurora-mysql"    = ["db.t3.small",   "2",   "5.7.mysql_aurora.2.10.2", "1",       "1",    "3306"],
  "aurora-mysql-hd" = ["db.t3.small",   "2",   "5.7.mysql_aurora.2.10.2", "1",       "1",    "3306"],
  "redshift"        = ["dc2.large",     "1",                                                 "5439"],
  "dms-instance"    = ["dms.t2.large",        "3.4.6",                                               false ]
  }
}

# Log Group [ retention_in_days  ]
# indefinite retention = 0
variable "log_groups" {
  default = {
    "bucket-antivirus-update"     = [ "30" ],
    "scan-bucket-file"            = [ "30" ],
    "update-clamav-definitions"   = [ "30" ],
    "mysql"                       = [ "30" ],
    "aspuser"                     = [ "30" ],
    "amazon-ssm-agent"            = [ "30" ],
    "chrony"                      = [ "30" ],
    "clamd.scan"                  = [ "30" ],
    "cloud-init"                  = [ "30" ],
    "cron"                        = [ "30" ],
    "messages"                    = [ "30" ],
    "secure"                      = [ "30" ],
    "clientvpn"                   = [ "30" ],
    "cloudtrail"                  = [ "30" ],
    "vpclogs"                     = [ "30" ],
    "dms"                         = [ "30" ],
    "msk"                         = [ "30" ]
  }
}

variable "event_categories" {
  default = {
      "redshift"        = ["configuration", "management", "monitoring", "security"],
      "dms_task"        = ["failure", "deletion", "state change"],
      "dms_instance"    = ["creation", "deletion",  "failover",   "failure", "low storage", "maintenance"],
      "rds"             = ["creation",  "deletion", "failover", "failure", "maintenance", "notification"],
      "rds_parameter"   = ["configuration change"]
  }
}

variable "event_notifications" {
  default = {
      "alarms_email"            = ["noc@airbiquity.com"],
      "ses_event_email"         = ["noc@airbiquity.com"],
      "ses_aqcloud_event_email" = ["noc@airbiquity.com"],
      "config-change_email"     = ["noc@airbiquity.com"]
  }
}

# Deploy listener for Uptane Time Service
variable "time-service" {
    default = false
}

variable "cross_account_sharing" {
     default = ["arn:aws:iam::704149553979:root"]
}

#### What AMI will be used for EC2 instances
# aws ec2 describe-images --owners 679593333241 --filters 'Name=name,Values=CentOS Linux 7 x86_64 HVM EBS *' 'Name=state,Values=available' 'Name=architecture,Values=x86_64' 'Name=root-device-type,Values=ebs' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
# https://wiki.centos.org/Cloud/AWS
variable "centos7_base" {
  default = {
    "us-east-2"       =  [""],
    "us-east-1"       =  [""],
    "us-west-1"       =  [""],
    "us-west-2"       =  ["ami-01ed306a12b7d1c96"],
    "af-south-1"      =  [""],
    "ap-east-1"       =  [""],
    "ap-south-1"      =  [""],
    "ap-northeast-3"  =  [""],
    "ap-northeast-2"  =  [""],
    "ap-southeast-1"  =  [""],
    "ap-southeast-2"  =  [""],
    "ap-northeast-1"  =  ["ami-045f38c93733dd48d"],
    "ca-central-1"    =  [""],
    "eu-central-1"    =  [""],
    "eu-west-1"       =  [""],
    "eu-west-2"       =  [""],
    "eu-south-1"      =  [""],
    "eu-west-3"       =  [""],
    "eu-north-1"      =  [""],
    "me-south-1"      =  [""],
    "sa-east-1"       =  [""]
  }
}

#### Tags that will be inherited by modules and resources
locals {
   global_tags_list = {
     "abq:name"        = "",
     "abq:oem"         = "abq",
     "abq:project"     = var.project,
     "abq:region"      = var.region,
     "abq:tag-version" = "1.0",
     "abq:tier"        = "na",
     "abq:version"     = "1.0",
     "abq:environment" = "${var.project}-${var.region}"
     "abq:group"       = "platform",
     "abq:deployer"    = "aq-pbh-deployer"
     }
  module_tags_list = merge(local.global_tags_list,{
       "abq:module"        = "config_root"
       })
}

#### VPN Configuration
variable "customer-gateway-address" {
  default = "72.165.62.111"
}

variable "vpn-connection-cidr" {
  default = "192.168.23.0/24"
}
variable "clientvpn-cidr" {
  default = "10.10.0.0/16"
}

#### Terraform S3 Backend Variables
variable "backend_bucket" {
  default = "terraform-state"
}

variable "dynamodb_lock_table_enabled" {
  type = bool
  default     = "1"
  description = "Affects terraform-aws-backend module behavior. Set to false or 0 to prevent this module from creating the DynamoDB table to use for terraform state locking and consistency. More info on locking for aws/s3 backends: https://www.terraform.io/docs/backends/types/s3.html. More information about how terraform handles booleans here: https://www.terraform.io/docs/configuration/variables.html"
}

variable "dynamodb_lock_table_stream_enabled" {
  type = bool
  default     = "0"
  description = "Affects terraform-aws-backend module behavior. Set to false or 0 to disable DynamoDB Streams for the table. More info on DynamoDB streams: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html. More information about how terraform handles booleans here: https://www.terraform.io/docs/configuration/variables.html"
}

variable "dynamodb_lock_table_stream_view_type" {
  default = "NEW_AND_OLD_IMAGES"
}

variable "dynamodb_lock_table_name" {
  default = "terraform-lock"
}

variable "lock_table_read_capacity" {
  default = 1
}

variable "lock_table_write_capacity" {
  default = 1
}

variable "kms_key_id" {
  # Default to absent/blank to use the default aws/s3 aws kms master key
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption on the tf state s3 bucket. If the kms_key_id is specified, the bucket default encryption key management method will be set to aws-kms. If the kms_key_id is not specified (the default), then the default encryption key management method will be set to aes-256 (also known as aws-s3 key management). The default aws/s3 AWS KMS master key is used if this element is absent (the default)."
}
