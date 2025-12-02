output "vpc_id" {
  description = "ID of the VPC created for the hybrid FaaS infra"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (for control/worker nodes, NLB, etc.)"
  value       = module.network.public_subnet_id
}
