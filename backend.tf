terraform {
  backend "s3" {
    bucket = "terraform-demo-temp20180114"
    key = "demo-5-custom"
  }
}
