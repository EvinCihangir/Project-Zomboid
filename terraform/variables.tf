variable "env" {
  type    = string
  default = "dev"
}

variable "pub_key" {
  description = "pubkey"
  type        = string
  sensitive   = true
}

# Default PZ ports for one server instance (UDP only)
variable "pz_udp_ports" {
  type    = list(number)
  default = [16261, 16262, 8766]
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"] # tighten in production
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
  sensitive   = true
}

variable "server_password" {
  description = "Server Password"
  type        = string
  sensitive   = true
}

variable "server_name" {
  type    = string
  default = "myserver"
}

variable "install_dir" {
  type    = string
  default = "/opt/pzserver"
}

variable "username" {
  type    = string
  default = "pz"
}

variable "instance_type" {
  type    = string
  default = "m5a.xlarge"
}

variable "vpc_main_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "subnet_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
