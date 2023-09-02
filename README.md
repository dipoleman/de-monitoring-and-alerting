# Monitoring and Alerting

This exercise is meant to test your understanding of using Cloudwatch logs as a source of alarms and alerting for potential errors.

The lambda defined in `src/mistaker.py` is designed to make mistakes. It has a random number generator that will cause errors if the generated number is a multiple of three or eleven. Additionally, it has been configured to take a random amount of time between 300 and 700 milliseconds.

## Setting Up

Please make sure you have setup and are authenticated with the AWS CLI

To deploy this very useful piece of software:

1. Fork, clone and `cd` into this repo
2. Run:

```bash
make all
```

3. In the shell, run:

```bash
./deployment/deploy.sh my.email@email.com
```

replacing the email address with your own. This script will create a Simple Notification Service (SNS) topic for the alert, which will be forwarded to your email address. You might want to copy the ARN of the topic, which should be output in your shell...

SNS Topic ARN: arn:aws:sns:eu-west-2:027026634773:test-error-alerts

Your subscription's id is:
arn:aws:sns:eu-west-2:027026634773:test-error-alerts:b8f99548-04f5-4d63-8238-f105b0cd6ea3

4. Check your email for a confirmation message from AWS with the title `AWS Notification - Subscription Confirmation`. When it arrives, click on the confirmation link.
5. Then change to the `terraform` directory and run:

```bash
terraform init
# output...
terraform plan
# output...
terraform apply
```

Then go have a cup of tea, coffee or other refreshment. A few minutes later, you can run this command:

```bash
aws logs tail /aws/lambda/mistaker-test --region eu-west-2
```

The application logs activity every minute so eventually you should see something similar to this:

```bash
2022-12-09T07:58:02.621000+00:00 2022/12/09/[$LATEST]11821906d1b44631bcd0c624a7423261 [WARNING]	2022-12-09T07:58:02.620Z	ee4748fc-bbde-4ab4-a054-7b673a27df13	Oh no 15 is divisible by 3
2022-12-09T07:58:02.621000+00:00 2022/12/09/[$LATEST]11821906d1b44631bcd0c624a7423261 [ERROR] MultipleOfFiveError
Traceback (most recent call last):
  File "/var/task/mistaker.py", line 16, in lambda_handler
    raise MultipleOfThreeError
```

## Tasks

Your main task is to create an alerting process that sends you an email whenever one of these "ERROR" log messages appears.

To do this, you will need to complete the terraform file `alarm.tf` with resources to:

1. [Make a metric filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) that spots the "ERROR" event.
1. [Create a Cloudwatch alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) based on the metric filter and which uses the SNS topic created by the script.

### Extensions

- Create different alerts for occurrences of `MultipleOfThreeError` and `RuntimeError`.
- Create an alert if the duration of code execution is longer than 600 ms.

If you have confirmed the SNS subscription, you should start getting emails alerting you to the errors. At some point you might want to `terraform destroy` to remove this infrastructure as you will likely get a _lot_ of emails. It's possible that some parts of the infrastructure (e.g. IAM...) will not destroy, but as long as the alarm itself is destroyed, you will not get any further spam.

- Add some monitoring and alerting to the s3 file reader example you made last week. Think about what scenarios you should monitor and setup appropriate alerts.
