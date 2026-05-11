variable "location" {
  type = string
}

variable "name" {
  type = string
}
variable "initial_node_count" {
  type = number
}
variable "remove_default_node_pool" {
  type = bool
}
variable "cn_id" {
  type = string
}
variable "scn_id" {
  type = string
}
variable "networking_mode" {
  type = string
}
variable "deletion_protection" {
  type = bool
}