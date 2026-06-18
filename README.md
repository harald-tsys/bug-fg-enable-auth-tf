# bug-fg-enable-auth-tf

```
resource "opentelekomcloud_fgs_function_v2" "fg_sample" {
  name = format("%s_%s", var.prefix, var.appname)
  app  = "default"

  agency = "fgs_default_agency"

  
  handler = "bootstrap"

  runtime = "http"

  code_type     = "zip"
  func_code     = filebase64(format("${path.module}/%s", var.zip_file))
  code_filename = basename(var.zip_file)

  description      = format("Sample function for %s", var.appname)
  memory_size      = 128
  timeout          = 30
  max_instance_num = 1

  #enable_auth_in_header = true
  enable_auth_in_header = false

}
```

changing `enable_auth_in_header` has no effect.

See: https://github.com/opentelekomcloud/terraform-provider-opentelekomcloud/issues/3429