import json

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Hello from Lambda via API Gateway!",
            "path": event.get("rawPath", ""),
            "method": event.get("requestContext", {}).get("http", {}).get("method", ""),
            "query": event.get("queryStringParameters", {})
        })
    }
