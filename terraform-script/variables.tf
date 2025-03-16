variable "cidr_block" {
  type        = string
  description = "Set cird block for VPC"
  default     = "10.0.0.0/16"
}

variable "instance_type_CI" {
  type        = string
  description = "Instance type for CI machine"
  default     = "t3.large"
}

variable "instance_type_CD" {
  type        = string
  description = "Instance type for CD machine"
  default     = "t3.large"
}