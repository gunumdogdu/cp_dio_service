import 'package:cp_dio_client/awesome_dio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioClient', () {
    final dioClient = DioClient('https://api.example.com');
    test('can make a GET request', () async {
      final response = await dioClient.request(HttpMethod.GET, '/users');

      expect(response?.statusCode, 200);
    });

    test('can make a POST request', () async {
      final response = await dioClient.request(
        HttpMethod.POST,
        '/users',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 201);
    });

    test('can make a PUT request', () async {
      final response = await dioClient.request(
        HttpMethod.PUT,
        '/users/1',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 200);
    });

    test('can make a DELETE request', () async {
      final response = await dioClient.request(
        HttpMethod.DELETE,
        '/users/1',
      );

      expect(response?.statusCode, 200);
    });

    test('can make a UPDATE request', () async {
      final response = await dioClient.request(
        HttpMethod.UPDATE,
        '/users/1',
        bodyParam: {'name': 'John Doe'},
      );

      expect(response?.statusCode, 200);
    });
  });
}
