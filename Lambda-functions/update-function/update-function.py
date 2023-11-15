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
            path_parameters = event['pathParameters']
            
            if route_key == 'PUT /items/{id}':
                tables = D.list_tables
                value = tables['TableNames']
                request_json = json.loads(event['body'])
                D.put_item ( 
                    TableName=value[0],
                    Item={
                        'id' : {'S' : path_parameters['id']},
                        'price' : {'S' : path_parameters['id']},
                        'name' : {'S' : path_parameters['id']} 
                    }
                )
                
                body = f"Put Item {path_parameters[id]}"
            else:
                raise ValueError(f"Unsupported route: '{route_key}'")
        except Exception as Error:
            body = str(Error)
            statusCode = 400
        
        finally:
        
          body = json.dumps(body)
        
        return{
            'body' : body,
            'statusCode' : statusCode,
            'headers' : headers
        }
        
            
            

    
    