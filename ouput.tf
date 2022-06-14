// Variable pour utilisé le nom du Bucket s3
output "website_bucket_name" {
    description = "Nom du bucket ou son ID"
    value       = module.website_s3_bucket.name
}
  
// Variable pour l'utilisation du nom de domaine de Bucket
output "website_endpoint" {
    description = "Nom du Domaine du Bucket"
    value       = module.website_s3_bucket.website_endpoint
}