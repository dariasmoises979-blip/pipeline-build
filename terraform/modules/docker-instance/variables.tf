variable "name" {
  type        = string
  description = "Nombre base de la instancia"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Número de instancias a crear"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Tipo de máquina GCE"
}

variable "zone" {
  type        = string
  default     = "europe-west1-b"
}

variable "image" {
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "network" {
  type    = string
  default = "default"
}

variable "metadata" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = list(string)
  default = []
}
