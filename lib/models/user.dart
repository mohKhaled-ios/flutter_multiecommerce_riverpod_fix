// class UserModel {
//   final String token;
//   final String id;
//   final String fullname;
//   final String email;
//   final String state;
//   final String city;
//   final String locality;
//   final String password;

//   UserModel({
//     required this.token,
//     required this.id,
//     required this.fullname,
//     required this.email,
//     required this.state,
//     required this.city,
//     required this.locality,
//     required this.password,
//   });

//   // ✅ factory لإنشاء نسخة من JSON
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       token: json['token'] ?? '',
//       id: json['_id'] ?? '',
//       fullname: json['fullname'] ?? '',
//       email: json['email'] ?? '',
//       state: json['state'] ?? '',
//       city: json['city'] ?? '',
//       locality: json['locality'] ?? '',
//       password: json['password'] ?? '',
//     );
//   }

//   // ✅ تحويل لـ JSON
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'fullname': fullname,
//       'email': email,
//       'state': state,
//       'city': city,
//       'locality': locality,
//       'password': password,
//     };
//   }
// }

class UserModel {
  final String token;
  final String id;
  final String fullname;
  final String email;
  late final String state;
  final String city;
  final String locality;
  final String password;

  UserModel({
    required this.token,
    required this.id,
    required this.fullname,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      id: json['_id'] ?? json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      '_id': id,
      'fullname': fullname,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      // لا تحفظ كلمة المرور فعلياً في التخزين إن لم تكن ضرورية:
      'password': password,
    };
  }
}
