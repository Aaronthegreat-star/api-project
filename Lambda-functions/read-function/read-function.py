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
        
        
        if route_key == 'GET /items':
            tables = D.list_tables()
            value = tables['TableNames']
            response = D.scan(
                TableName=value[0]
            )
            body = response['Items']
                
        elif route_key == 'GET /items/{id}':
            path_parameters = event['pathParameters']
            tables = D.list_tables()
            value = tables['TablesNames']
            response = D.get_item(
                TableName=value[0],
                key= {
                    'id' : {'S': path_parameters[id]}
                }
            )
            body = response['Item']
        else:
            raise ValueError(f"Unsupported route: '{route_key}'")
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

    
        
        
        
        
            
    
    
    