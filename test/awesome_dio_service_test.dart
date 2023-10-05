import 'package:cp_dio_client/awesome_dio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioClient', () {
    final dioClient = DioClient('https://api.example.com');
    test('can make a GET request', () async {
      final response = await dioClient.request(DioHttpMethod.GET, '/users');

      expect(response?.statusCode, 200);
    });

    test('can make a POST request', () async {
      final response = await dioClient.request(
        DioHttpMethod.POST,
        '/users',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 201);
    });

    test('can make a PUT request', () async {
      final response = await dioClient.request(
        DioHttpMethod.PUT,
        '/users/1',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 200);
    });

    test('can make a DELETE request', () async {
      final response = await dioClient.request(
        DioHttpMethod.DELETE,
        '/users/1',
      );

      expect(response?.statusCode, 200);
    });

    test('can make a UPDATE request', () async {
      final response = await dioClient.request(
        DioHttpMethod.UPDATE,
        '/users/1',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 200);
    });
  });
}
