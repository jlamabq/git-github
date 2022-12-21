#!/bin/bash


#./terraform destroy -auto-approve -target module.cloudwatch
#./terraform destroy -auto-approve -target aws_codecommit_repository.projectrepo
./terraform destroy -auto-approve -target aws_ssm_parameter.application_psk
./terraform destroy -auto-approve -target module.management
./terraform destroy -auto-approve -target module.iam
./terraform destroy -auto-approve -target module.ses
./terraform destroy -auto-approve -target module.elb
./terraform destroy -auto-approve -target module.ec2
./terraform destroy -auto-approve -target module.rds
./terraform destroy -auto-approve -target module.elb
./terraform destroy -auto-approve -target module.cloudtrail
# DEstroy Snapshots

./terraform destroy -auto-approve -target module.kms

### Empty S3 Content
export profile="abq-ops-sit-terraform"; export project="abq-ops-sit"; export region="us-west-2";
#export bucketlist='aq-training-us-west-2-smoketest'

aws cloudtrail stop-logging --name $project'-'$region'-all-events-trail' --profile $profile --region $region;

bucketlist=`aws s3 ls --profile $profile --region $region | awk '{ print $NF }' | grep $project'-'$region`;
# Suspend Versioning
for bucket in $bucketlist; do aws s3api put-bucket-versioning --profile $profile --region $region --bucket $bucket --versioning-configuration Status=Suspended; done;
# Stop Logging
for bucket in $bucketlist; do aws s3api put-bucket-logging --profile $profile --region $region --bucket $bucket --bucket-logging-status '{}'; done;
# Stop access
for bucket in $bucketlist; do aws s3api delete-bucket-policy --profile $profile --region $region --bucket $bucket ; done;

# Empty Buckets
for bucket in $bucketlist; do aws s3 rm --profile $profile --region $region s3://$bucket  --recursive; done;
# Delete Markers
for bucket in $bucketlist; do export bucket=$bucket; echo -e `aws s3api list-object-versions --bucket $bucket --output=text --query="{Objects: Versions[].{Key:Key,VersionId:VersionId}}" --profile $profile --region $region  | awk '{print " aws s3api delete-object --bucket $bucket --profile $profile --region $region --version-id \"" $3 "\" --key \"" $2 "\""}' ` ; done;

# Delete Versions
for bucket in $bucketlist; do export bucket=$bucket; echo -e `aws s3api list-object-versions --bucket $bucket --output=text --query="{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}" --profile $profile --region $region  | awk '{print " aws s3api delete-object --bucket $bucket --profile $profile --region $region --version-id \"" $3 "\" --key \"" $2 "\""}' `  ; done;


for bucket in $bucketlist; do aws s3 rb --profile $profile --region $region s3://$bucket --force; done;

##### DISale cloudtrail

./terraform destroy -auto-approve --target module.s3
# Check buckets

./terraform destroy -auto-approve --target module.vpc
./terraform destroy -auto-approve -target module.cloudfront
./terraform destroy -auto-approve

for resource in `./terraform state list`; do ./terraform destroy -auto-approve --target  $resource; done;

# Remove RDS snapshots
for snapshot in `aws rds describe-db-snapshots --query "DBSnapshots[*].DBSnapshotIdentifier" --output=text --profile $profile --region $region`; do aws rds delete-db-snapshot --db-snapshot-identifier $snapshot --profile $profile --region $region; done
