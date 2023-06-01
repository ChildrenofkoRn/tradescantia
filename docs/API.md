# API
REST API with OAuth 2 ([Authorization Code Flow](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1))

In order to use the API you need:
* Must be a logged in user
* Register your application: https://tradescantia.example.com/oauth/applications
* Once your application receives the token it can make requests to the API

## Root endpoint
```
/api/v1
```

## About API versioning
The API version is indicated by an index at the end of the root endpoint:
```
api/v{API_VERSION}
```
Only the first version of the API is currently available.

## Which data formats are available?
At the moment its JSON format.

## Top Level
The root element of the `data`.  
This complies with the JSON API specification: https://jsonapi.org/format/#document-top-level


All fields (except `id` and `type`) are included in the `attributes` key.
* id - resource indicator
* type - resource type

## Available resources and actions
At the moment its available to get information about `Profiles` is implemented:

### Profiles
* `/profiles/me` - Your account info
  #### Returnable fields:
    * id
    * username
    * created_at
    * updated_at
    * reviews_count
    * average_rank_given

  If you are an administrator, you will have access to additional fields:
    * email
    * type

* `/profiles/index` - The list of users is returned, the available fields are analogous to `/me`.
  >**Limitations**   
  >User receives a list that doesn't include administrative profiles.  
  >Administrators get the full list.


## Example
* get request `https://tradescantia.example.com/api/v1/profiles/me?access_token=XXX`
* response:
    ```json
    {
        "data": {
            "id": "1",
            "type": "profile",
            "attributes": {
                "username": "Moonlight",
                "created_at": "2023-02-22T02:27:40.919+03:00",
                "updated_at": "2023-04-20T16:08:44.366+03:00",
                "email": "Moonlight@example.com",
                "type": "Admin",
                "reviews_count": "13",
                "average_rank_given": "4.53"
            }
        }
    }
    
    ```

