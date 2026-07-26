import json

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Hello from Lambda deployed via Terraform!",
            "event": event
        })
    }
