variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "mongodb_url" {
  description = "MongoDB connection URL"
  type        = string
}

variable "clerk_publishable_key" {
  description = "Clerk publishable key for authentication"
  type        = string
}

variable "clerk_secret_key" {
  description = "Clerk secret key for authentication"
  type        = string
}

variable "cloudinary_api_key" {
  description = "Cloudinary API key for image management"
  type        = string
}

variable "cloudinary_api_secret" {
  description = "Cloudinary API secret for image management"
  type        = string
}

variable "stripe_secret_key" {
  description = "Stripe secret key for payment processing"
  type        = string
}

variable "stripe_publishable_key" {
  description = "Stripe publishable key for payment processing"
  type        = string
}

variable next_public_cloudinary_cloud_name {
  description = "Cloudinary cloud name for client-side configuration"
  type    = string
}

variable "next_public_clerk_sign_in_url" {
  type    = string
  default = "/sign-in"
}

variable "next_public_clerk_sign_up_url" {
  type    = string
  default = "/sign-up"
}

variable "next_public_clerk_after_sign_in_url" {
  type    = string
  default = "/"
}

variable "next_public_clerk_after_sign_up_url" {
  type    = string
  default = "/"
}