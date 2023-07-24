variable "location" {
  default = "us-east-2"
}

variable "os_name" {
  default = "ami-024e6efaf93d85776"
}

variable "key" {
  default = "easymedia"
}

variable "instance-type" {
  default = "t2.large"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "subnet1-cidr" {
  default = "10.0.1.0/24"

}
variable "subent_az" {
  default = "us-east-2a"
}