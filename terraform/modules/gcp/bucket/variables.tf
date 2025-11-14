#--------------------------------
# GCP Bucket Module - Variables
#--------------------------------

variable "bucket_name" {
    description = "The name of the GCP Storage Bucket"
    type        = string
    default     = "value"
}

variable "location" {
    description = "The location/region of the GCP Storage Bucket"
    type        = string
    default     = "US"
  
}

variable "force_destroy" {
    description = "Whether to force destroy the bucket (deletes all objects)"
    type        = bool
    default     = false
}

variable "project_id" {
    description = "The GCP Project ID where the bucket will be created"
    type        = string
}

variable "user_email" {
    description = "The email of the user to be granted access to the bucket"
    type        = string
  
}


variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "grant_write_access" {
  description = "Grant write access to the user"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket"
  type = list(object({
    action = string
    age    = number
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to the bucket"
  type        = map(string)
  default     = {}
}

