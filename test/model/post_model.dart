class TestPosts {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  TestPosts({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory TestPosts.fromJson(Map<String, dynamic> json) => TestPosts(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
