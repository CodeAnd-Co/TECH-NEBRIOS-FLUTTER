class LoginRespuesta {
  final int status;
  final String token;

  LoginRespuesta({required this.status, required this.token});

  factory LoginRespuesta.fromJson(Map<String, dynamic> json) {
    return LoginRespuesta(
      status: json['status'],
      token: json['token'],
    );
  }
}