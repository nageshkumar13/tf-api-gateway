import json
import logging

# Example data
data = {
    "items": [
        {"id": 1, "name": "Banana", "price": 50, "Size": "Dozen"},
        {"id": 2, "name": "Flour", "price": 70, "Size": "Kg."}, 
        {"id": 3, "name": "Milk", "price": 55.50, "Size": "litre"},
    ]
}

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Log the event
    logger.info("Event: %s", json.dumps(event))

    # Determine the HTTP method of the request
    http_method = event["httpMethod"]

    if http_method == "GET":
        # Return the data in the response
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(data)
        }
    elif http_method == "POST":
        # Retrieve the request's body and parse it as JSON
        body = json.loads(event["body"])
        # Add the received data to the example data
        data["items"].append(body)
        # Return the updated data in the response
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(data)
        }
    elif http_method == "PUT":
        # Retrieve the request's body and parse it as JSON
        body = json.loads(event["body"])
        # Update the example data with the received data
        for item in data["items"]:
            if item["id"] == body["id"]:
                item.update(body)
                break
        # Return the updated data in the response
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(data)
        }
    elif http_method == "DELETE":
        # Retrieve the request's body and parse it as JSON
        body = json.loads(event["body"])
        # Find the item with the specified id in the example data
        for i, item in enumerate(data["items"]):
            if item["id"] == body["id"]:
                # Remove the item from the example data
                del data["items"][i]
                break
        # Return the updated data in the response
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(data)
        }
    else:
        # Return an error message for unsupported methods
        response = {
            "statusCode": 405,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": "Method not allowed"})
        }

    return response
