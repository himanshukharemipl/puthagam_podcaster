class LoginParams {
  String? email;
  String? password;

  LoginParams({this.email, this.password});

  factory LoginParams.fromJson(Map<String, dynamic> json) => LoginParams(
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "emailOrPhone": "lee@yopmail.com",
        "authKey": "a553ac68-58a6-476f-ba54-40459765a1a7",
      };
}
