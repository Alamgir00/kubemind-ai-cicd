output "pipeline_name" { value = aws_codepipeline.this.name }
output "artifact_bucket_arn" { value = aws_s3_bucket.artifacts.arn }
output "artifact_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
output "github_connection_arn" { value = aws_codeconnections_connection.github.arn }
output "github_connection_status" { value = aws_codeconnections_connection.github.connection_status }
