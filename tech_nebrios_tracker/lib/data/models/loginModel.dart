class LoginRespuesta {
  final int code;
  final String token;

  LoginRespuesta({required this.code, required this.token});

  factory LoginRespuesta.fromJson(Map<String, dynamic> json) {
    return LoginRespuesta(
      code: json['code'],
      token: json['token'],
    );
  }
}