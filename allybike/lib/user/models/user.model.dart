class User {
  int id;
  String name;
  String email;
  String? phone;
  String? image;
  bool isAlly;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAlly,
    this.phone,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    isAlly: json["isAlly"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
    "isAlly": isAlly
  };
}


