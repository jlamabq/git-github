terraform {

  backend "s3" {
    bucket         = "corn-us-west-2-terraform-state"
    key            = "state/corn-us-west-2.tfstate"
    dynamodb_table = "corn-us-west-2_terraform-lock"
    encrypt        = "true"
    region         = "us-west-2"
    profile        = "devops"
    #### vi ~/.aws/credentials
  }
}
