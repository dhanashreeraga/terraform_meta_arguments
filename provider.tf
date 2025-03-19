provider "aws" {
  region = "ap-south-1"
}
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}