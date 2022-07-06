provider "aws" {
  region = "us-east-1"
}


resource "null_resource" "zip_lambda_layer" {
  provisioner "local-exec" {
    command = "${path.module}/build.sh ${var.dist_path}"
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${var.dist_path}/layer.zip"
  layer_name = var.layer_name

  compatible_runtimes = ["python${var.python_version}"]
  depends_on          = [null_resource.zip_lambda_layer]
}





