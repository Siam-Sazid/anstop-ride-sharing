class ResetPasswordRequestModel {
  final String password;

  ResetPasswordRequestModel({required this.password});

  Map<String, dynamic> toJson() => {'password': password};
}
