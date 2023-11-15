import json
import boto3

D = boto3.client('dynamodb')
def lambda_handler(event, context):
    body = None
    statusCode = 200
    headers = {
        'Content-Type' : 'application/json'
    }
    
    try:
        route_key = event['routeKey']
        
        if route_key == 'POST /items':
            response = D.list_tables()
            value = response['TableNames']
            request_json = json.loads(event['body'])
            
            D.put_item(
                TableName=value[0],
                Item = {
                    'id' : {'S' : request_json['id']},
                    'name' : {'S' : request_json['name']},
                    'price' : {'S' : request_json['price']}
                }
            )
            body = f"Post Item {request_json['id']}"
            
        else: 
            raise ValueError(f"Unsupported route : '{route_key}'")
            
    except Exception as Error:
        body = str(Error)
        statusCode = 400
        
    finally:
        body = json.dumps(body)
    
    return {
        
        'body' : body,
        'statusCode' : statusCode,
        'headers' : headers     
    }
            