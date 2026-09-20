output "budget_name" {
  value = aws_budgets_budget.this.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}
