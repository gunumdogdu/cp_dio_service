import 'package:cp_dio_client/awesome_dio_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'model/post_model.dart';

void main() {
  group('DioClient', () {
    final dioClient = DioClient.instance(
      'jsonplaceholder.typicode.com',
      onUnauthorized: () {},
    );
    test('can make a GET request', () async {
      final data = await dioClient.request<TestPosts>(DioHttpMethod.GET, 'posts', forceRefresh: true);

      expect(data.response!.statusCode, 200);
    });
/* 
    test('can make a POST request', () async {
      final data = await dioClient.request(
        DioHttpMethod.POST,
        'posts/add',
        bodyParam: {"title": 'I am in love with someone.', "userId": "5"},
      );

      expect(data.response!.statusCode, 201);
    }); */
  });
}
