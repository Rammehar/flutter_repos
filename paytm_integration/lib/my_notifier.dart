class UserModel {
  List<User> users = [];
  void addUser(User user) {
    users.add(user);
  }
}

class User {
  String name;
  String address;
  String phoneNo;
  User({this.name, this.address, this.phoneNo});
}
