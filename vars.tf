// Page pour enregistrer les différentes variables pour des raccourcies
variable "AWS_KEY_ACCESS" {
    type = string
}

variable "AWS_KEY_SECRET" {
    type = string
}

variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}

variable "AWS_AMI" {
    type = string
}

variable "SSH_PUB_KEY" {
  type = string
}