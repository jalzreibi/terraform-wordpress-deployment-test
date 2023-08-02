variable "availability_zone" {
  default = "eu-west-1b"
}
variable "mariadb_ami_id" {
  default = "ami-04e8e181fd6046bf5"
}
variable "wordpress_ami_id" {
  default = "ami-08dfcfa12a75f5842"
}
variable "mariadb_ssh_key" {
  default = "mariadb-server1-prod"
}
variable "wordpress_ssh_key" {
  default = "wordpress-server1-prod"
}
variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = false
}
variable "green-wordpress-count" {
  type    = number
  default = 1
}
variable "green-mariadb-count" {
  type    = number
  default = 1
}
variable "traffic_dist_map" {
  type = map(object({
    blue  = number
    green = number
  }))
  default = {
    "blue" = {
      blue  = 100
      green = 0
    }
    "blue-80" = {
      blue  = 80
      green = 20
    }
    "split" = {
      blue  = 50
      green = 50
    }
    "green-80" = {
      blue  = 20
      green = 80
    }
    "green" = {
      blue  = 0
      green = 100
    }
  }
}
variable "traffic" {
  description = "Levels of traffic distribution"
  type        = string
  default     = "blue"
}
