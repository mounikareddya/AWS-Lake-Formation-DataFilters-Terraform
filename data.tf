data "template_file" "filters" {
  count = length(var.stack)
  template = templatefile("${path.module}/${local.filter_template_file}.json.tpl", {
    TableCatalogId = var.aws_account_id
    DatabaseName = var.stack[count.index].database_name
    TableName = var.stack[count.index].table_name
    Name = var.stack[count.index].filter_name
    RowFilterValue = var.stack[count.index].row_filter_value
    ColumnName = var.stack[count.index].column_name         
  })
}
