class UserStats {

  final int id;
  final String username;
  final int productsCount;

  UserStats({
    required this.id,
    required this.username,
    required this.productsCount,
  });

  factory UserStats.fromJson(
      Map<String, dynamic> json) {

    return UserStats(
      id: json['id'],
      username: json['username'],
      productsCount:
          int.parse(
              json['products_count']
                  .toString()),
    );
  }
}