class User {
  final String id;
  final int userId;
  final String email;
  final String fullName;
  final String password;
  final String livePlace;
  final int phoneNumber;
  final String dateOfBirth;
  final bool isAdmin;
  final String role;
  final String jwtToken;
  final List<dynamic> wishlist;
  final String updatedAt;
  final int v;

  User({
    required this.id,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.password,
    required this.livePlace,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.isAdmin,
    required this.role,
    required this.jwtToken,
    required this.wishlist,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      password: json['password'] ?? '',
      livePlace: json['livePlace'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      dateOfBirth: json['dateOfBirth'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      role: json['role'] ?? '',
      jwtToken: json['jwtToken'] ?? '',
      wishlist: List<dynamic>.from(json['wishlist'] ?? []),
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}

final Map<String, dynamic> jsonResponse = {
  "getaUser": {
    "_id": "653ae56fe5ee0ed13b2610ed",
    "user_id": 50,
    "email": "ahmad@gmail.com",
    "fullName": "ahamd madc",
    "password": "2b10YQmS/36GhCzrQDKEzmwM0eqEUllaekUvbN14WaYzytopU9iR.I/Iu",
    "livePlace": "Nablus",
    "phoneNumber": 592073408,
    "isAdmin": false,
    "role": "user",
    "jwtToken": null,
    "wishlist": [],
    "updatedAt": "2023-10-26T22:17:19.258Z",
    "__v": 0
  }
};
