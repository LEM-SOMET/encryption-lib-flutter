class UserModel {
  final String id;
  final String user;
  final String position;

  UserModel({
    required this.id,
    required this.user,
    required this.position,
  });

  UserModel copyWith({
    String? id,
    String? user,
    String? position,
  }) =>
      UserModel(
        id: id ?? this.id,
        user: user ?? this.user,
        position: position ?? this.position,
      );

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: json["id"],
        user: json["user"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "position": position,
      };
}
