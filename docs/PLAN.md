## Terraform + Cloud Task Set

| Status | Area             | Task                               | What you should be able to do                                            |
| -- | ---------------- | ---------------------------------- | ------------------------------------------------------------------------ |
| [x] | Terraform basics | Create an EC2 instance             | Write provider, resource, security group, key pair, output public IP     |
| [x] | Terraform basics | Terminate EC2 using Terraform      | Remove resource from code and run `terraform destroy` or `apply` cleanly |
| [x] | Terraform basics | Create S3 bucket                   | Add versioning, encryption, public access block                          |
| [x] | Terraform basics | Attach IAM role to EC2             | Create role, policy, instance profile, attach to instance                |
| [x] | Terraform basics | Deploy Lambda                      | Package zip, create function, attach execution role                      |
| [x] | Terraform basics | Create API Gateway + Lambda        | Expose Lambda through HTTP endpoint                                      |
| [x] | Terraform basics | Use variables and outputs          | Pass values through `.tfvars`, print useful outputs                      |
| [x] | Terraform basics | Use remote state                   | Store state in S3 with DynamoDB lock                                     |
| [ ] | AWS core         | Connect EC2 to S3                  | Use IAM role on EC2 and AWS CLI to access bucket                         |
| [ ] | AWS core         | Read/write file from S3 in EC2     | `aws s3 cp`, `sync`, and basic permission handling                       |
| [ ] | AWS core         | Create private/public subnet setup | Place EC2 in correct subnet with route tables                            |
| [ ] | AWS core         | Make EC2 accessible securely       | Security group only, no hardcoded keys, use SSH or SSM                   |
| [ ] | AWS core         | Create RDS and connect app to it   | Build DB, allow port access, use endpoint in app config                  |
| [ ] | AWS core         | Add CloudWatch logs                | Send app logs or system logs to CloudWatch                               |
| [ ] | AWS core         | Create Auto Scaling Group          | Launch template + scaling policy + load balancer                         |

---

## Small Real-World Labs

| Status | Lab                  | Goal                                                   |
| -- | -------------------- | ------------------------------------------------------ |
| [ ] | Static website on S3 | Host a site using bucket + policy + CloudFront         |
| [ ] | App on EC2           | Deploy a simple app on EC2 and serve it through Nginx  |
| [ ] | Lambda from S3 event | Trigger Lambda when a file lands in S3                 |
| [ ] | EC2 backup task      | Copy files from EC2 to S3 on schedule                  |
| [ ] | Bastionless access   | Use AWS Systems Manager Session Manager instead of SSH |
| [ ] | CI/CD for Terraform  | Run `fmt`, `validate`, `plan` in GitHub Actions        |
| [ ] | Cleanup script       | Delete idle resources safely with tags and dry-run     |

---

## Interview-style questions to practice

| Question                                                | What they test                                 |
| ------------------------------------------------------- | ---------------------------------------------- |
| How do you terminate an EC2 in Terraform?               | Resource lifecycle, `destroy`, state           |
| How do you connect S3 to EC2?                           | IAM role and AWS CLI knowledge                 |
| How do you deploy Lambda with Terraform?                | Packaging, permissions, runtime setup          |
| How do you manage Terraform state?                      | Remote backend, locking, teamwork              |
| How do you secure an S3 bucket?                         | Bucket policy, encryption, public access block |
| How do you give EC2 access to S3 without keys?          | IAM role on instance                           |
| What is the difference between security group and NACL? | Network basics                                 |
| How do you troubleshoot Terraform apply failure?        | Debugging and state awareness                  |

---

## Best order to practice

| Level  | Topics                                                       |
| ------ | ------------------------------------------------------------ |
| Easy   | EC2, S3, security groups, variables                          |
| Medium | IAM role, Lambda, remote state, CloudWatch                   |
| Hard   | API Gateway + Lambda, Auto Scaling, S3 event triggers, CI/CD |

---

## Rule to avoid repeating this mistake

For every cloud topic, prepare these 4 things:

| Must know | Example                    |
| --------- | -------------------------- |
| Create    | Terraform code             |
| Change    | Add/update/remove resource |
| Delete    | Clean termination          |
| Explain   | Why you used it            |


