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
        path_parameters = event['path_parameters']
        
        if route_key == 'DELETE /items/{id}':
            tables = D.list_tables()
            value = tables['TableNames']
            D.delete_item(
            TableName = value[0],
         key= {
            'id' : {'S' : path_parameters['id']}
        }
        )
        
            body = f"Deleted item {path_parameters['id']}"
        
        else:
            raise ValueError("Unsupported route : '{route_key}'")
    
    except Exception as Error:
        statusCode = 400
        body = str(Error)
        
    finally:
        body = json.dumps(body)
        
    return{
        'body' : body,
        'statusCode' : statusCode,
        'headers' : headers
    }
        
            
        