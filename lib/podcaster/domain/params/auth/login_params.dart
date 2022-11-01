class LoginParams {
  String? email;
  String? password;

  LoginParams({this.email, this.password});

  factory LoginParams.fromJson(Map<String, dynamic> json) => LoginParams(
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
