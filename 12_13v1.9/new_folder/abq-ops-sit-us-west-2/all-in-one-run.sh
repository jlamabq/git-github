#!/bin/bash

####  Locate the AMI IDs Accept Terms ####
# https://aws.amazon.com/marketplace/server/procurement?productId=b7ee8a69-ee97-4a49-9e68-afaee216db2e

date

export profile="devops"; export project="corn"; export region="us-west-2";



aws sts get-caller-identity --region $region --profile $profile

# EC2 terms and conditions

./terraform init
echo "------------ sleep 10 ------------"
sleep 10

./terraform apply -auto-approve --target module.cloudtrail.aws_cloudwatch_log_group.all-events-trail --target module.cloudwatch.aws_cloudwatch_log_group.vpclogs --target module.ec2.aws_cloudwatch_log_group.aspuser --target module.ec2.aws_cloudwatch_log_group.amazon-ssm-agent --target module.ec2.aws_cloudwatch_log_group.chrony --target module.ec2.aws_cloudwatch_log_group.clamd-scan --target module.ec2.aws_cloudwatch_log_group.cloud-init --target module.ec2.aws_cloudwatch_log_group.cron --target module.ec2.aws_cloudwatch_log_group.messages --target module.ec2.aws_cloudwatch_log_group.secure --target module.ec2.aws_cloudwatch_log_group.msk --target module.rds.aws_cloudwatch_log_group.dms-replication-task --target module.rds.aws_cloudwatch_log_group.mysql-error 

aws iam create-role --profile $profile --region $region --role-name 'dms-access-for-endpoint'  --assume-role-policy-document '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "Service": "dms.amazonaws.com" }, "Action": "sts:AssumeRole" } ]}';
aws iam create-role --profile $profile --region $region --role-name 'dms-cloudwatch-logs-role' --assume-role-policy-document '{ "Version": "2012-10-17",  "Statement": [ { "Sid": "1", "Effect": "Allow", "Principal": { "Service": "dms.amazonaws.com" }, "Action": "sts:AssumeRole" }, { "Sid": "2", "Effect": "Allow", "Principal": { "Service": "redshift.amazonaws.com" }, "Action": "sts:AssumeRole" } ]}';
aws iam create-role --profile $profile --region $region --role-name 'dms-vpc-role'             --assume-role-policy-document '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "Service": "dms.amazonaws.com" }, "Action": "sts:AssumeRole" } ]}';

echo "------------ sleep 10 ------------"
sleep 10

./terraform apply -auto-approve -target module.s3.aws_s3_bucket.logs
./terraform apply -auto-approve -target module.s3.aws_s3_bucket.repository

./terraform apply -auto-approve -target module.s3

./terraform import module.vpc.aws_guardduty_detector.guardduty  `aws guardduty list-detectors  --profile $profile --region $region --output text | awk '{print $NF}'`

./terraform apply -auto-approve -target module.vpc

./terraform import module.rds.aws_iam_role.dms-access-for-endpoint dms-access-for-endpoint
./terraform import module.rds.aws_iam_role.dms-cloudwatch-logs-role dms-cloudwatch-logs-role
./terraform import module.rds.aws_iam_role.dms-vpc-role dms-vpc-role

./terraform apply -auto-approve -target module.rds -target module.cloudfront

./terraform apply -auto-approve -target module.management

echo "------------ sleep 10 ------------"
sleep 10

./terraform apply -auto-approve -target module.elb.aws_acm_certificate.STAR-CERTIFICATE-SELF -target module.elb.aws_acm_certificate.STAR-CERTIFICATE-PUB -target module.ec2.aws_eip.management-eip

echo "------------ sleep 10 ------------"
sleep 10

### Management VM and sysmanager_role
./terraform apply -auto-approve -target module.ec2.aws_instance.managment-vm -target module.ec2.aws_eip.management-eip --target module.managemnt.aws_iam_role.sysmanager_role --target module.managemnt.aws_iam_role_policy_attachment.AmazonEC2RoleforSSM --target module.managemnt.aws_iam_role_policy_attachment.AmazonSSMFullAccess --target module.managemnt.aws_iam_role_policy_attachment.ResourceGroupsandTagEditorFullAccess --target module.managemnt.aws_iam_role_policy_attachment.AmazonS3FullAccess --target module.managemnt.aws_iam_role_policy_attachment.kmsencryptpolicy --target module.managemnt.aws_iam_role_policy_attachment.CloudWatchLogsFullAccess --target module.managemnt.aws_iam_role_policy_attachment.CloudWatchFullAccess --target module.managemnt.aws_iam_role_policy_attachment.CloudWatchEventsFullAccess --target module.managemnt.aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy


echo "------------ sleep 10 ------------"
sleep 10

./terraform apply -auto-approve -target module.sns -target module.kms -target module.iam


# Stop unnecessary SSM
for ID in `aws ssm list-commands --profile $profile --region $region --query 'Commands[?Status==\`InProgress\`].[DocumentName, CommandId ]' --output text | grep $project | grep -v 'setup_management' | awk '{print $NF}'`; do aws ssm cancel-command --command-id $ID --profile $profile --region $region; done;

aws ssm list-commands --profile $profile --region $region --query 'Commands[?Status==`InProgress`].[DocumentName, CommandId, Status ]' --output text

echo "------------ sleep 10 ------------"

./terraform apply -auto-approve -target module.elb  -target module.rds  -target module.ses  -target module.cloudfront
echo "------------ sleep 10 ------------"
sleep 10


./terraform apply  -auto-approve --target aws_s3_bucket.tf_backend_bucket --target aws_s3_bucket.tf_backend_logs_bucket --target aws_dynamodb_table.tf_backend_state_lock_table --target aws_iam_policy_document.tf_backend_bucket_policy --target aws_s3_bucket_policy.tf_backend_bucket_policy
if [ `ls | grep -c  enable-s3-backend.tf.disable` -gt 0 ]; then mv enable-s3-backend.tf.disable enable-s3-backend.tf ; fi;
date
./terraform init


###### WHEN Managmenet VM is ready Complete deployment:
########################## Setup Managment then complete deployment ##########################

## List SSM Docs
# aws ssm list-associations --profile $profile --region  $region --query 'Associations[*].[Name, AssociationId ]' --output text | grep $project

## Cancel Running SSM Docs (except managemnt)
# for ID in `aws ssm list-command-invocations --profile $profile --region $region --query 'CommandInvocations[*].[DocumentName, CommandId, Status ]' --output text | grep "InProgress" | grep $project | grep -v 'setup_management'  | awk '{print $2}'`; do aws ssm cancel-command --command-id $ID --profile $profile --region $region; done;

## List Running SSM Docs
# aws ssm list-command-invocations --profile $profile --region $region --query 'CommandInvocations[*].[DocumentName, CommandId, Status ]' --output text | grep "InProgress" | grep $project

## Start SSM Setup Management
# for ID in `aws ssm list-associations --profile $profile --region  $region --query 'Associations[*].[Name, AssociationId ]' --output text | grep $project | grep 'setup_management' | awk '{print $NF}'`; do aws ssm start-associations-once --association-ids $ID --profile $profile --region $region; done;

## Start SSM 'ansible-managment\|check_kafka\|aspuser\|clamav'
# for ID in `aws ssm list-associations --profile $profile --region  $region --query 'Associations[*].[Name, AssociationId ]' --output text | grep $project | grep 'ansible-managment\|check_kafka\|aspuser\|clamav' | awk '{print $NF}'`; do aws ssm start-associations-once --association-ids $ID --profile $profile --region $region; done;

## Start ALL SSM
# for ID in `aws ssm list-associations --profile $profile --region  $region --query 'Associations[*].[Name, AssociationId ]' --output text | grep $project | awk '{print $NF}'`; do aws ssm start-associations-once --association-ids $ID --profile $profile --region $region; done;

#Skip Clam and setup_management
# for ID in `aws ssm list-associations --profile $profile --region  $region --query 'Associations[*].[Name, AssociationId ]' --output text | grep $project | grep -v 'clam\|setup_management' | awk '{print $NF}'`; do aws ssm start-associations-once --association-ids $ID --profile $profile --region $region; done;

# Add Transit Gateway ID for "transit-gateway" bundle-bundle in variables.tf

###### WHEN Managmenet VM is ready Complete deployment:
### ./terraform apply -auto-approve
