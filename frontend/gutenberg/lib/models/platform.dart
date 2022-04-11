 class Platform {
  int? pk;
  late String login;
  late String password;
  late String email;
  late String phoneNumber;
  late String platform;
  late String user;

  Platform(
    {
      this.pk,
      required this.login,
      required this.password,
      required this.email,
      required this.phoneNumber,
      required this.platform,
      required this.user
    }
  );

  Platform.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    login = json['login'];
    password = json['password'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    platform = json['platform'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['login'] = login;
    data['password'] = password;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['platform'] = platform;
    data['user'] = user;
    return data;
  }
}