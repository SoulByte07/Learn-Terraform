#!/bin/bash
set -euo pipefail

BUCKET_NAME="${bucket_name}"
USE_LOCALSTACK="${use_localstack}"
LOCALSTACK_ENDPOINT="${localstack_endpoint}"
AWS_REGION="${aws_region}"

echo "===== EC2 -> S3 connection bootstrap ====="

# AWS CLI v2 ships pre-installed on Amazon Linux 2023.
if ! command -v aws &>/dev/null; then
  echo "Installing AWS CLI v2..."
  cd /tmp
  curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install
fi

# LocalStack: IAM role credentials do NOT propagate inside the VM.
# Fall back to static creds + host endpoint so bucket listing still works for demos.
if [ "${USE_LOCALSTACK}" = "true" ]; then
  echo "LocalStack mode detected."
  echo "NOTE: instance role credentials are not available inside a LocalStack VM;"
  echo "using static credentials and the host endpoint instead."
  export AWS_ACCESS_KEY_ID="test"
  export AWS_SECRET_ACCESS_KEY="test"
  export AWS_DEFAULT_REGION="${AWS_REGION}"
  export AWS_ENDPOINT_URL="${LOCALSTACK_ENDPOINT}"
fi

echo
echo "1. AWS CLI version:"
aws --version

echo
echo "2. Current identity (should be the IAM role on real AWS):"
aws sts get-caller-identity || echo "(identity check failed - expected in LocalStack mode)"

echo
echo "3. Listing bucket s3://${BUCKET_NAME}/ :"
aws s3 ls "s3://${BUCKET_NAME}/" || echo "(bucket listing failed)"

echo
echo "4. Reading s3://${BUCKET_NAME}/hello.txt :"
aws s3 cp "s3://${BUCKET_NAME}/hello.txt" - || echo "(object read failed)"

echo
echo "===== EC2 -> S3 connection verification complete ====="
