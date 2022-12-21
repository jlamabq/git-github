terraform {
  required_version = "= 1.0.7"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.60.0"

    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}


module "vpc" {
  #source                  = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//vpc?ref=aq-infra-deployer"
  source                   = "../../aq-pbh-deployer/vpc/"
  region                   = var.region
  aws-privatednszone       = var.aws-privatednszone
  availability_zones       = var.availability_zones
  project                  = var.project
  network                  = var.network
  sns-alarm-topic          = module.sns.sns-alarm-topic
  customer-gateway-address = var.customer-gateway-address
  vpn-connection-cidr      = var.vpn-connection-cidr
  clientvpn-cidr           = var.clientvpn-cidr
  profile                  = var.profile
  transit-gateway          = var.transit-gateway
  transit-gateway-common   = var.transit-gateway-common
  global_tags_list         = local.global_tags_list
}

# module "clientvpn" {
#   #source                  = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//clientvpn?ref=aq-infra-deployer"
#   source                   = "../../aq-pbh-deployer/clientvpn/"
#   region                   = var.region
#   project                  = var.project
#   vpc_id                   = module.vpc.vpc_id
#   aws-privatednszone       = var.aws-privatednszone
#   network                  = var.network
#   subnets                  = module.vpc.subnets
#   securitygroups           = module.vpc.securitygroups
#   sns-alarm-topic          = module.sns.sns-alarm-topic
#   customer-gateway-address = var.customer-gateway-address
#   vpn-connection-cidr      = var.vpn-connection-cidr
#   clientvpn-cidr           = var.clientvpn-cidr
#   profile                  = var.profile
#   log_groups               = var.log_groups
#   global_tags_list         = local.global_tags_list
# }

module "s3" {
  #source           = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//s3?ref=aq-infra-deployer"
  source            = "../../aq-pbh-deployer/s3/"
  region            = var.region
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  network           = var.network
  route-public      = module.vpc.route-public
  route-private     = module.vpc.route-private
  release           = var.release
  endpoints         = module.vpc.endpoints
  global_tags_list  = local.global_tags_list
}

module "elb" {
  #source                  = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//elb?ref=aq-infra-deployer"
  source                   = "../../aq-pbh-deployer/elb/"
  region                   = var.region
  project                  = var.project
  default-identifier       = var.default-identifier
  vpc_id                   = module.vpc.vpc_id
  subnets                  = module.vpc.subnets
  aws-dnszone              = var.aws-dnszone
  abq-dnszone              = var.abq-dnszone
  aws-privatednszone       = var.aws-privatednszone
  termination-protection   = var.termination-protection
  sns-alarm-topic          = module.sns.sns-alarm-topic
  securitygroups           = module.vpc.securitygroups
  pub-certificate          = var.pub-certificate
  self-certificate         = var.self-certificate
  self-certificate-aqcloud = var.self-certificate-aqcloud
  abq-pub-certificate      = var.abq-pub-certificate
  instance_map             = var.instance_map
  time-service             = var.time-service
  waf_configuration        = var.waf_configuration
  public_urls              = local.public_urls
  config_integration       = var.config_integration
  global_tags_list         = local.global_tags_list
}

module "kms" {
  #source                = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//kms?ref=aq-infra-deployer"
  source                 = "../../aq-pbh-deployer/kms/"
  region                 = var.region
  project                = var.project
  vpc_id                 = module.vpc.vpc_id
  sysmanager_role_arn    = module.management.sysmanager_role_arn
  global_tags_list       = local.global_tags_list
}

module "management" {
  #source              = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//management?ref=aq-infra-deployer"
  source                 = "../../aq-pbh-deployer/management/"
  region                 = var.region
  project                = var.project
  default-identifier     = var.default-identifier
  env-identifier         = var.env-identifier
  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.subnets
  aws-dnszone            = var.aws-dnszone
  abq-dnszone            = var.abq-dnszone
  aws-privatednszone     = var.aws-privatednszone
  kms-key-id             = module.kms.kms-key-id
  loadbalancer_url       = module.elb.loadbalancer_url
  db_instance            = module.rds.db_instance
  cloudfront-cdn         = module.cloudfront.cloudfront-cdn
  #use_msk               = var.use_msk
  application_encryption        = var.application_encryption
  bucket_list            = module.cloudfront.bucket_list
  release                = var.release
  endpoints              = module.vpc.endpoints
  instance_map           = var.instance_map
  public_urls            = local.public_urls
  config_integration     = var.config_integration
  global_tags_list       = local.global_tags_list
  acm-pca-common-name    = var.acm-pca-common-name
}

module "ec2" {
  #source                = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//ec2?ref=aq-infra-deployer"
  source                 = "../../aq-pbh-deployer/ec2/"
  region                 = var.region
  project                = var.project
  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.subnets
  instance_map           = var.instance_map
  centos7_base           = var.centos7_base
  #use_msk               = var.use_msk
  #use_vpn               = var.use_vpn
  sysmanager_role        = module.management.sysmanager_role
  sysmanager_profile     = module.management.sysmanager_profile
  ec2_root_key_name      = "${var.project}-${var.region}-ec2_root-key"
  aws-dnszone            = var.aws-dnszone
  abq-dnszone            = var.abq-dnszone
  aws-privatednszone     = var.aws-privatednszone
  securitygroups         = module.vpc.securitygroups
  loadbalancer-tg_arn    = module.elb.loadbalancer-tg_arn
  loadbalancer_url       = module.elb.loadbalancer_url
  sysmanager_id          = module.management.sysmanager_id
  sysmanager_secret      = module.management.sysmanager_secret
  sns-alarm-topic        = module.sns.sns-alarm-topic
  termination-protection = var.termination-protection
  log_groups             = var.log_groups
  global_tags_list       = local.global_tags_list
}

module "rds" {
  #source                    = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//rds?ref=aq-infra-deployer"
  source                     = "../../aq-pbh-deployer/rds/"
  region                     = var.region
  project                    = var.project
  profile                    = var.profile
  vpc_id                     = module.vpc.vpc_id
  instance_map               = var.instance_map
  securitygroups             = module.vpc.securitygroups
  aws-privatednszone         = var.aws-privatednszone
  availability_zones         = var.availability_zones
  database-subnet-group      = module.vpc.database-subnet-group
  subnets                    = module.vpc.subnets
  termination-protection     = var.termination-protection
  sns-alarm-topic            = module.sns.sns-alarm-topic
  log_groups                 = var.log_groups
  event_categories           = var.event_categories
  user_accounts              = var.user_accounts
  global_tags_list           = local.global_tags_list
}

module "ses" {
  #source             = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//ses?ref=aq-infra-deployer"
  source              = "../../aq-pbh-deployer/ses/"
  region              = var.region
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  ses_domain          = var.aws-dnszone
  ses_aqcloud         = var.abq-dnszone
  profile             = var.profile
  event_notifications = var.event_notifications
  global_tags_list    = local.global_tags_list
}

module "sns" {
  #source             = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//sns?ref=aq-infra-deployer"
  source              = "../../aq-pbh-deployer/sns/"
  region              = var.region
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  profile             = var.profile
  event_notifications = var.event_notifications
  global_tags_list    = local.global_tags_list
}

module "cloudfront" {
  #source                = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//cloudfront?ref=aq-infra-deployer"
  source                 = "../../aq-pbh-deployer/cloudfront/"
  region                 = var.region
  project                = var.project
  default-identifier     = var.default-identifier
  vpc_id                 = module.vpc.vpc_id
  restriction_type       = var.restriction_type
  geo_restriction        = var.geo_restriction
  s3_encryption-key      = module.s3.s3_encryption-key
  endpoints              = module.vpc.endpoints
  aws-dnszone            = var.aws-dnszone
  abq-public-sni-cert    = var.abq-public-sni-cert
  abq-private-sni-cert   = var.abq-private-sni-cert
  abq-dnszone            = var.abq-dnszone
  sni-cert               = var.sni-cert
  public_urls            = local.public_urls
  config_integration     = var.config_integration
  global_tags_list       = local.global_tags_list
}

module "cloudwatch" {
  #source             = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//cloudwatch?ref=aq-infra-deployer"
  source              = "../../aq-pbh-deployer/cloudwatch/"
  region              = var.region
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  sysmanager_role_arn = module.management.sysmanager_role_arn
  ec2_instance-list   = module.ec2.ec2_instance-list
  sns-alarm-topic     = module.sns.sns-alarm-topic
  loadbalancer_arn    = module.elb.loadbalancer_arn
  loadbalancer-tg_arn = module.elb.loadbalancer-tg_arn
  log_groups          = var.log_groups
  profile             = var.profile
  global_tags_list    = local.global_tags_list
  cross_account_sharing = var.cross_account_sharing
}

# module "config" {
#   #source           = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//config?ref=aq-infra-deployer"
#   source            = "../../aq-pbh-deployer/config/"
#   region            = var.region
#   project           = var.project
#   vpc_id            = module.vpc.vpc_id
#   sns_topic_arn     = module.sns.sns-config-topic
#   global_tags_list  = local.global_tags_list
# }

module "iam" {
  #source           = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//iam?ref=aq-infra-deployer"
  source            = "../../aq-pbh-deployer/iam/"
  region            = var.region
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  global_tags_list  = local.global_tags_list
}

# module "cloudtrail" {
#   #source           = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//cloudtrail?ref=aq-infra-deployer"
#   source            = "../../aq-pbh-deployer/cloudtrail/"
#   region            = var.region
#   project           = var.project
#   vpc_id            = module.vpc.vpc_id
#   s3_encryption-key = module.s3.s3_encryption-key
#   log_groups        = var.log_groups
#   global_tags_list  = local.global_tags_list
# }

module "lambda-logs" {
  #source    = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//lambda?ref=aq-infra-deployer"
  source     = "../../aq-pbh-deployer/lambda-logs/"
  region     = var.region
  project    = var.project
  vpc_id     = module.vpc.vpc_id
  log_groups = var.log_groups
  global_tags_list       = local.global_tags_list
}

module "lambda-log-archive" {
  #source           = "git::https://vc1.airbiquity.com/infrastructure/aq-infra-deployer.git//lambda?ref=aq-infra-deployer"
  source            = "../../aq-pbh-deployer/lambda-log-archive/"
  region            = var.region
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  log_groups        = var.log_groups
  global_tags_list  = local.global_tags_list
}

#module "acm-pca" {
#  source              = "../../aq-pbh-deployer/acm-pca/"
#  region              = var.region
#  project             = var.project
#  vpc_id              = module.vpc.vpc_id
#  endpoints           = module.vpc.endpoints
#  aws-dnszone         = var.aws-dnszone
#  global_tags_list    = local.global_tags_list
#}
