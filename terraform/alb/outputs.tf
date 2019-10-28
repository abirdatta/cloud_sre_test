output "alb_dns" {
  value = module.alb_and_target_group.alb_dns
}

output "alb_arn" {
  value = module.alb_and_target_group.alb_arn
}

output "alb_id" {
  value = module.alb_and_target_group.alb_id
}

output "alb_name" {
  value = module.alb_and_target_group.alb_name
}

output "target_group_arn" {
  value = module.alb_and_target_group.target_group_arn
}