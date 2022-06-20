# Data-filter

## ModuleInfo 

- This module creates single or multiple data filters in AWS datalake for a given database table.


### Bundle Requirements

| TF Version | AWS CLI |
| --- | --- | 
| >0.14 | V2 |

## Module Usage 

- This module expects the variable "stack" as a list of objects type map.
- Each list item is a map of filter name, database name, table name, table catalog ID, column name and, row filter expression.
- The format for stack variable and account id variable is as below:

```
stack = [
   {
            database_name      = "<enter DB name in which the above table exists>"
            table_name         = "<enter table name here>"
            filter_name        = "<enter filter name>"
            column_name        = "<table column name>"
            row_filter_value   = "<table row column value"
    }
    {
            database_name      = "<enter DB name in which the above table exists>"
            table_name         = "<enter table name here>"
            filter_name        = "<enter filter name>"
            column_name        = "<table column name>"
            row_filter_value   = "<table row column value"
    }
    ...
]

```
- This module uses a local variable called "filter_template_file". The template file name must be "filter-template.json.tpl" in the local workspace (reference file included in this repo).
- In order to use this module, the local workspace must consist of variable file called vars.auto.tfvars.
- The auto vars should have stack and aws_account_id in it.

## References
- AWS Data Lake Formation = https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html
- AWS CLI = https://aws.amazon.com/cli/
- Terraform CLI = https://www.terraform.io/cli/commands
