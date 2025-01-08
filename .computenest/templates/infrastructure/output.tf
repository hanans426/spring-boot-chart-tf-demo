output "server_address" {
  description = <<EOT
      {
        "Label": "访问地址",
        "Description": "页面访问地址."
      }
      EOT
  value  = format("http://test:8080")
}
