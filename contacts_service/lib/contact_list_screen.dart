import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hardware_call_app/home_screen.dart';
import 'package:hardware_call_app/utils/permission_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  bool isVisible = false;
  int? selectedIndex;
  final _searchController = TextEditingController();

  @override
  void initState() {
    checkContactPermission();
    super.initState();
  }

  Future<void> checkContactPermission() async {
    final permission = await PermissionUtils.getContactPermission();
    switch (permission) {
      case PermissionStatus.granted:
        fetchContacts();
        break;
      case PermissionStatus.permanentlyDenied:
        goBack();
        break;
      default:
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please Allow")));
        break;
    }
  }

  Future<void> fetchContacts() async {
    final listOfContacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = listOfContacts;
    });

    //lazy load contacts
    for (final contact in listOfContacts) {
      ContactsService.getAvatar(contact).then(
        (avatar) {
          if (avatar == null) return;
          setState(() {
            contact.avatar = avatar;
          });
        },
      );
    }
  }

  void goBack() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: SizedBox(
            height: 35,
            child: TextField(
              controller: _searchController,
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                    const VerticalDivider(),
                    const Icon(Icons.more_vert),
                    const SizedBox(width: 5),
                  ],
                ),
                filled: true,
                fillColor: const Color(0xffF6F8FA),
                isDense: true,
                contentPadding: const EdgeInsets.all(0),
                hintText: "Search contact",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: contacts.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];

                    if (_searchController.text.isEmpty) {
                      return Column(
                        children: [
                          ListTile(
                            selected: index == selectedIndex,
                            onTap: () {
                              showHide(index);
                            },
                            leading: (contact.avatar != null &&
                                    contact.avatar!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                  )
                                : Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Colors.blueGrey.shade300,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(contact.initials()),
                                  ),
                            title: Text(contact.displayName.toString()),
                          ),
                          Visibility(
                            visible: selectedIndex == index,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.grey.shade50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _contactFunctionality(
                                    "Call",
                                    Icons.phone,
                                    Colors.green,
                                    () {
                                      _makePhoneCall("9060875000");
                                    },
                                  ),
                                  _contactFunctionality(
                                      "Call", Icons.phone, Colors.green),
                                  _contactFunctionality("Message",
                                      FontAwesomeIcons.comment, Colors.pink),
                                  _contactFunctionality("Video call",
                                      FontAwesomeIcons.video, Colors.green),
                                  _contactFunctionality(
                                      "Details", Icons.info, Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (contact.displayName!
                        .toLowerCase()
                        .contains(_searchController.text)) {
                      return Column(
                        children: [
                          ListTile(
                            selected: index == selectedIndex,
                            onTap: () {
                              showHide(index);
                            },
                            leading: (contact.avatar != null &&
                                    contact.avatar!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                  )
                                : Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Colors.blueGrey.shade300,
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(contact.initials()),
                                  ),
                            title: Text(contact.displayName.toString()),
                          ),
                          Visibility(
                            visible: selectedIndex == index,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.grey.shade50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _contactFunctionality(
                                    "Call",
                                    Icons.phone,
                                    Colors.green,
                                    () {
                                      _makePhoneCall("9060875000");
                                    },
                                  ),
                                  _contactFunctionality(
                                      "Call", Icons.phone, Colors.green),
                                  _contactFunctionality("Message",
                                      FontAwesomeIcons.comment, Colors.pink),
                                  _contactFunctionality("Video call",
                                      FontAwesomeIcons.video, Colors.green),
                                  _contactFunctionality(
                                      "Details", Icons.info, Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
      ),
    );
  }

  void showHide(int index) {
    setState(() {
      selectedIndex = index;
      isVisible = !isVisible;
    });
  }

  Widget _contactFunctionality(String text, IconData iconData, Color color,
      [VoidCallback? onPressed]) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 12,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    // final Uri launchUri = Uri(
    //   scheme: 'tel',
    //   path: phoneNumber,
    // );
    // await launch(launchUri.toString());
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
