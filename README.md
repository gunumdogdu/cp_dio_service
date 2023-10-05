## DioClient

The `DioClient` class is a wrapper around the Dio library that provides a number of features, including:

* A consistent API for making HTTP requests.
* Automatic caching of responses.
* Logging of all requests and responses.
* Error handling.

## Usage

To use the `DioClient` class, you would first create a new instance of the class, passing in the base URL of the API that you want to call. For example:

```dart
final dioClient = DioClient('https://api.example.com');
```

Once you have created a `DioClient` instance, you can use it to make HTTP requests by calling the `request()` method. The `request()` method takes the following parameters:

* `method`: The HTTP method to use (GET, POST, PUT, DELETE, etc.).
* `path`: The path to the endpoint that you want to call.
* `bodyParam`: A map of body parameters to send with the request.
* `headerParam`: A map of header parameters to send with the request.
* `forceRefresh`: Whether or not to force a refresh of the cached response.
* `openThread`: Whether or not to open a new thread to make the request.

The `request()` method returns a `Future` object that resolves to a `Response` object. The `Response` object contains the response from the API, including the status code, headers, and body.

For example, the following code shows how to make a GET request to the `/users` endpoint:

dart
final response = await dioClient.request(HttpMethod.GET, '/users');


The `response` variable will now contain a `Response` object with the response from the API. You can then use the `response` object to access the status code, headers, and body.

## Example

The following example shows how to use the `DioClient` class to make a GET request to the `/users` endpoint and print the response to the console:

``` dart
import 'package:awesome_dio_service/awesome_dio_service.dart';

void main() async {
  final dioClient = DioClient('https://api.example.com');

  final response = await dioClient.request(HttpMethod.GET, '/users');

  if (response.statusCode == 200) {
    print(response.data);
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

## Caching

The `DioClient` class automatically caches responses. This means that subsequent requests to the same endpoint will return the cached response, unless you specify otherwise.

To force a refresh of the cached response, you can set the `forceRefresh` parameter to `true` when calling the `request()` method.

## Logging

The `DioClient` class logs all requests and responses. This can be useful for debugging and troubleshooting.

To disable logging, you can set the `logger` property of the `DioClient` instance to `null`.

## Error handling

The `DioClient` class handles errors automatically. If an error occurs, the `request()` method will throw a `DioError` exception.

You can catch the `DioError` exception and handle it as needed. For example, you could log the error or display it to the user.

## Conclusion

The `DioClient` class is a powerful tool for making HTTP requests in Dart. It provides a number of features that make it easy to use, including:

* A consistent API for making HTTP requests.
* Automatic caching of responses.
* Logging of all requests and responses.
* Error handling.
