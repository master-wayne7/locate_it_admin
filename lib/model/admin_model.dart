class AdminModel {
  // String? uid;
  String? email;
  String? name;

  AdminModel({this.email, this.name});

  factory AdminModel.fromMap(map) {
    return AdminModel(email: map['email'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name};
  }
}
