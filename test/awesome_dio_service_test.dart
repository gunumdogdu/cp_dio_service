import 'package:cp_dio_client/awesome_dio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioClient', () {
    final dioClient = DioClient.instance(
      'https://jsonplaceholder.typicode.com/',
      onUnauthorized: () {},
    );
    test('can make a GET request', () async {
      final response = await dioClient.request(DioHttpMethod.GET, 'posts', forceRefresh: true);

      expect(response?.statusCode, 200);
    });

    test('can make a POST request', () async {
      final response = await dioClient.request(
        DioHttpMethod.POST,
        'posts/add',
        bodyParam: {"title": 'I am in love with someone.', "userId": "5"},
      );

      expect(response?.statusCode, 201);
    });
  });
}
