#!/bin/bash
set -euo pipefail

BUCKET_NAME="${bucket_name}"
USE_LOCALSTACK="${use_localstack}"
LOCALSTACK_ENDPOINT="${localstack_endpoint}"
AWS_REGION="${aws_region}"
PERMISSIONS_MODE="${permissions_mode}"
WRITE_PREFIX="${write_prefix}"

echo "===== EC2 -> S3 read/write demo ====="
echo "Bucket:        ${BUCKET_NAME}"
echo "Permission:    ${PERMISSIONS_MODE}"
echo "Write prefix:  ${WRITE_PREFIX}"

# AWS CLI v2 ships pre-installed on Amazon Linux 2023.
if ! command -v aws &>/dev/null; then
  echo "Installing AWS CLI v2..."
  cd /tmp
  curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  ./aws/install
fi

# LocalStack: IAM role credentials do NOT propagate inside the VM.
# Fall back to static creds + host endpoint so the bucket demo still works.
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
echo "===== 1. IDENTITY (should be the IAM role on real AWS) ====="
aws sts get-caller-identity || echo "(identity check failed - expected in LocalStack mode)"

echo
echo "===== 2. READ: list bucket ====="
aws s3 ls "s3://${BUCKET_NAME}/" || echo "(list failed)"

echo
echo "===== 3. READ: download object ====="
aws s3 cp "s3://${BUCKET_NAME}/hello.txt" /tmp/hello.txt && cat /tmp/hello.txt

echo
echo "===== 4. WRITE: upload to bucket root ====="
echo "uploaded-by-ec2" > /tmp/upload.txt
if aws s3 cp /tmp/upload.txt "s3://${BUCKET_NAME}/upload.txt"; then
  echo "RESULT: root upload SUCCEEDED"
else
  echo "RESULT: root upload DENIED (expected in read_only / read_write_prefix mode)"
fi

echo
echo "===== 5. WRITE: upload into prefix ${WRITE_PREFIX}/ ====="
mkdir -p /tmp/sync
echo "alpha" > /tmp/sync/a.txt
echo "beta"  > /tmp/sync/b.txt
if aws s3 cp /tmp/sync/a.txt "s3://${BUCKET_NAME}/${WRITE_PREFIX}/a.txt"; then
  echo "RESULT: prefix upload SUCCEEDED"
else
  echo "RESULT: prefix upload DENIED (expected in read_only mode)"
fi

echo
echo "===== 6. SYNC: local dir -> bucket prefix ====="
if aws s3 sync /tmp/sync "s3://${BUCKET_NAME}/${WRITE_PREFIX}/sync/"; then
  echo "RESULT: sync SUCCEEDED"
  aws s3 ls --recursive "s3://${BUCKET_NAME}/${WRITE_PREFIX}/sync/"
else
  echo "RESULT: sync DENIED (expected in read_only mode)"
fi

echo
echo "===== 7. PERMISSION BOUNDARY: write outside allowed scope ====="
echo "boundary-test" > /tmp/boundary.txt
if aws s3 cp /tmp/boundary.txt "s3://${BUCKET_NAME}/outside-scope.txt"; then
  echo "RESULT: boundary write SUCCEEDED (full write mode)"
else
  echo "RESULT: boundary write DENIED as expected (AccessDenied - outside write scope)"
fi

echo
echo "===== EC2 -> S3 read/write demo complete ====="
