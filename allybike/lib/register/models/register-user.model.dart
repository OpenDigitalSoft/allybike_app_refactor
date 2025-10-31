
class RegisterUserRequest {
  String name;
  String email;
  String? phone;
  String password;


  RegisterUserRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) =>
      RegisterUserRequest(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
  };
}
