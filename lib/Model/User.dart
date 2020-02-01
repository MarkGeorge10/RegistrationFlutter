class User {
  int userID;
  String accessToken,
      type,
      name,
      phoneNumber,
      password,
      passwordConfirmation,
      address;

  User({
    this.accessToken,
    this.userID,
    this.name,
    this.type,
    this.phoneNumber,
    this.password,
    this.passwordConfirmation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userID: json['id'],
        name: json['name'],
        phoneNumber: json['phone'],
        accessToken: json['access_token']);
  }
  Map toLogin() {
    var map = new Map<String, dynamic>();
    map["type"] = type;
    map["phone"] = phoneNumber;
    map["password"] = password;

    return map;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["type"] = type;
    map["name"] = name;
    map["phone"] = phoneNumber;
    map["password"] = password;
    map["password_confirmation"] = passwordConfirmation;
    return map;
  }
}
