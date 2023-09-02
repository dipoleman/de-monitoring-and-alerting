resource "aws_cloudwatch_log_metric_filter" "three_error" {
  name           = "Three-Error"
  pattern        = "WARNING"
  log_group_name = "/aws/lambda/mistaker-test"

  metric_transformation {
    name      = "ThreeErrorCount"
    namespace = "LambdaErrorNotification"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "three_alert_errors" {
  alarm_name          = "Three-Error-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  namespace           = "LambdaErrorNotification"
  metric_name         = "ThreeErrorCount"
  statistic           = "Sum"
  period              = 120
  threshold           = 2
  alarm_description   = "This metric monitors mod 3 errors eminating from lambda"
  alarm_actions       = ["arn:aws:sns:eu-west-2:027026634773:test-error-alerts"]
}

resource "aws_cloudwatch_log_metric_filter" "eleven_error" {
  name           = "Eleven-Error"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/mistaker-test"

  metric_transformation {
    name      = "ElevenErrorCount"
    namespace = "LambdaErrorNotification"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "eleven_alert_errors" {
  alarm_name          = "Eleven-Error-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  namespace           = "LambdaErrorNotification"
  metric_name         = "ElevenErrorCount"
  statistic           = "Sum"
  period              = 120
  threshold           = 2
  alarm_description   = "This metric monitors mod 11 errors eminating from lambda"
  alarm_actions       = ["arn:aws:sns:eu-west-2:027026634773:test-error-alerts"]
}



# REPORT RequestId: 30069352-7dc3-4182-b332-75b802b08b14	Duration: 373.20 ms
resource "aws_cloudwatch_log_metric_filter" "lambda_execution_time" {
  name           = "Lambda-Execution-Time"
  pattern        = "[report=REPORT, id, num, duration, time, ...]"
  log_group_name = "/aws/lambda/mistaker-test"

  metric_transformation {
    name          = "LambdaExecutionTime"
    namespace     = "LambdaErrorNotification"
    value         = "$time"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_exicution_time_alert" {
  alarm_name          = "lambda_exiction_time_alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  namespace           = "LambdaErrorNotification"
  metric_name         = "LambdaExecutionTime"
  statistic           = "Sum"
  period              = 60
  threshold           = 600
  alarm_description   = "This metric monitors the exicution time of the lambda function if it exceeds 600ms"
  alarm_actions       = ["arn:aws:sns:eu-west-2:027026634773:test-error-alerts"]
}


