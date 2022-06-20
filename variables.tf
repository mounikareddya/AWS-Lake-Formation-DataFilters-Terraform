variable "stack" {
  description = "Template containing consumption patterns for infrastructure to be created."
  type = list(
      object(
          {
            database_name    = string
            table_name       = string
            filter_name      = string
            column_name      = string
            row_filter_value = string
          }
      )
  )
}

variable "aws_account_id" {
    type = number
}