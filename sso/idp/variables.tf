variable "name" {
  type = string
}

variable "saml_metadata_document" {
  description = "The IdP's SAML metadata XML, as a string. Pass it in (e.g. file(\"metadata.xml\")) rather than hardcoding it in a module so no specific IdP's metadata ships with this repo."
  type        = string
}
