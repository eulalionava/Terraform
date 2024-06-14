variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "homepage" {
  description = "The URL to the application's home page."
  type        = string
}

variable "identifier_uris" {
  description = "A list of identifier URIs for the application."
  type        = list(string)
}

variable "reply_urls" {
  description = "A list of reply URLs for the application."
  type        = list(string)
}

variable "client_secret" {
  description = "The client secret for the application."
  type        = string
}

variable "client_secret_end_date" {
  description = "The end date for the client secret."
  type        = string
}