

####  Console ####  
https://612362735572.signin.aws.amazon.com/console

#### Resource Availability
https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/
https://docs.aws.amazon.com/general/latest/gr/rande.html#ec2_region
# aws ec2 describe-availability-zones --region $REGION

####  Locate the AMI IDs Accept Terms ####
https://aws.amazon.com/marketplace/server/procurement?productId=b7ee8a69-ee97-4a49-9e68-afaee216db2e

##################################################################################

#### Clean up a previous TF for a new deployment
cd <the project directory>
\rm -rdf .git
\rm -rdf .terraform
find . -type f -name .DS_Store -exec rm {} \;
\rm  ec2/*
\rm clientvpn/*.ovpn
mv enable-s3-backend.tf enable-s3-backend.tf.disable
echo "" > cloudfront/private.pem
echo "" > cloudfront/public.pem
\rm  elb/self-certs/*.zip
\rm *.log
\rm *tfstate*

####  Update the Variables.tf

##################################################################################
### Setup your AWS Subscription and CLI credentials
# Install AWS CLI
https://aws.amazon.com/cli/
/usr/local/bin/aws configure

# Random Password "openssl rand -base64 14"

# Enter "Access keys for CLI" from your account "My security credentials"
vi ~/.aws/credentials

[profile]
aws_access_key_id =
aws_secret_access_key =

######################## CDN CloudFront Signing Key ######################
# 1 - Login to the 'root' account
# 2 - Go to "root-account > My Security Credentials > CloudFront key pairs"
# 3 - Create New Key Pair save public/private certificates
# 4 - Place "public.pem" and "private.pem" in the cloudfront module

##################################################################################
### Initial deployment MOP
/Applications/terraform init

### Deploy Network / Storage / IAM users & policies
/Applications/terraform apply --target module.vpc
/Applications/terraform apply --target module.s3
/Applications/terraform apply --target module.sns
/Applications/terraform apply --target module.elb.aws_acm_certificate.STAR-CERTIFICATE-SELF --target module.elb.aws_acm_certificate.STAR-CERTIFICATE-PUB
/Applications/terraform apply --target module.elb --target module.kms
/Applications/terraform apply --target module.ec2
/Applications/terraform apply --target module.rds --target module.cloudfront
/Applications/terraform apply --target module.management


### Launch CloudFront (20-minutes)
/Applications/terraform apply --target module.cloudfront

#When the "CentOS/7/os/x86_64/repodata" folder is populated in S3 proceed to the next step

### Launch all remaining modules
/Applications/terraform apply

## Then edit and uncomment the "backend s3" block in the root main.tf
#/Applications/terraform apply

## Remove old teraform.state file from folder
## Setup Git
#git init
#git add .
#git remote add origin <Repo-URL>
#git commit -a -m "first push"
#git push -u origin master
## IN IAM add "AWSCodeCommitFullAccess" Permissions. In Security.
## IN IAM go to user's Security credentials tab and click "HTTPS Git credentials for AWS CodeCommit".
