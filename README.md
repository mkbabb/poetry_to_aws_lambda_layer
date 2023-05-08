# `poetry_to_aws_lambda_layer`

Terraform module to create a Lambda Python Layer from a Poetry project. Currently
supports `manylinux1_x86_64` wheels.

## Usage

```hcl
module "make_layer" {
    source         = "git@github.com:mkbabb/ poetry_to_aws_lambda_layer.git"

    name           = "tmp_layer"   
    dist_path      = "./dist"
    extra_paths    = "./src/.."
    python_version = "3.10"
}
```

## [Input Variables](/variables.tf)

-   `layer_name` - Name of the layer
-   `dist_path` - Path to the `dist` (build) folder of the project
-   `extra_paths` - List of extra paths to include in the layer
-   `python_version` - Python version to use for the layer
