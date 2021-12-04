import 'package:flutter/material.dart';
import 'package:paytm_integration/my_notifier.dart';

import 'my_inherited_widget.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyInheritedWidget(
        userModel: UserModel(),
        child: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String name, address, phoneNo;

  @override
  Widget build(BuildContext context) {
    MyInheritedWidget myProvider = MyInheritedWidget.of(context);
    return Center(
      child: Column(
        children: [
          Text("Add New User"),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter A Name!"),
            onChanged: (value) {
              name = value;
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter A Address!"),
            onChanged: (value) {
              address = value;
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter A Phone No!"),
            onChanged: (value) {
              phoneNo = value;
            },
          ),
          FlatButton(
              onPressed: () {
                saveValue(myProvider);
              },
              child: Text("Save Data")),
          MyUsersList(),
        ],
      ),
    );
  }

  saveValue(MyInheritedWidget myProvider) {
    setState(() {
      myProvider.userModel
          .addUser(User(name: name, address: address, phoneNo: phoneNo));
    });
  }
}

class MyUsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyInheritedWidget myProvider = MyInheritedWidget.of(context);

    return Container(
      child: Text("${myProvider.userModel.users.length}"),
    );
  }
}
