locals {
  filter_template_file = "filter-template"
}

##################################################################
#  Prepares logical data object Filters Json code
##################################################################

resource "local_file" "filters" {
  count    = length(var.stack)
  filename = "${path.module}/${local.filter_template_file}-${count.index + 1}.json"
  content  = data.template_file.filters[count.index].rendered

  depends_on = [
    data.template_file.filters
  ]
}

# The below null resource doesn't have any tags supported.
resource "null_resource" "create-filters" {
  count = length(var.stack)
  provisioner "local-exec" {
    when    = create
    command = <<EOF

          FilterName="${var.stack[count.index].filter_name}"
          echo "Filter Name $FilterName"  
          cmd=$(aws lakeformation list-data-cells-filter --table CatalogId=${var.aws_account_id},DatabaseName=${var.stack[count.index].database_name},Name=${var.stack[count.index].table_name} --output text --query "DataCellsFilters[].[Name]" | grep ${var.stack[count.index].filter_name})
          if [[ "${var.stack[count.index].filter_name}" == "$cmd" ]]; then
            echo "Filter ${var.stack[count.index].filter_name} Exists!"
            rm ${local.filter_template_file}-${count.index + 1}.json
          else
            echo "Creating Filter ${var.stack[count.index].filter_name}"
            aws lakeformation create-data-cells-filter --cli-input-json file://${local.filter_template_file}-${count.index + 1}.json
            rm ${local.filter_template_file}-${count.index + 1}.json
            echo "Create Filter ${var.stack[count.index].filter_name} Ok!"
          fi 
    EOF
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    local_file.filters
  ]

}

resource "null_resource" "delete-filters" {
  count = length(var.stack)
  triggers = {
    table_catalog_id = var.aws_account_id
    database_name    = var.stack[count.index].database_name
    table_name       = var.stack[count.index].table_name
    filter_name      = var.stack[count.index].filter_name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<BASH
      aws lakeformation delete-data-cells-filter --name ${self.triggers.filter_name} --table-catalog-id ${self.triggers.table_catalog_id} --database-name ${self.triggers.database_name} --table-name ${self.triggers.table_name} --region us-east-1 
      echo "Deleting the filter"    
    BASH

  }

  depends_on = [
    null_resource.create-filters
  ]
}
