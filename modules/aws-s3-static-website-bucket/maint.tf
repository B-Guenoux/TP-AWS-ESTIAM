// Création du Bucket s3 avec ses configurations
resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.bucket_name
    acl    = "public-read"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF

    website {
        index_document = "index.html"
        error_document = "error.html"
    }
}

// module pour récuperer la fonction lambda
module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"

    function_name = "guenoux-lambda"
    description = "Fonction lambda pour le TP de Estiam"
    handler = "index.lambda_handler"
    runtime = "python3.8"

    source_path = "../src/lambda_function_tp"

    tags = {
        Name = "guenoux-lambda"
    }
}