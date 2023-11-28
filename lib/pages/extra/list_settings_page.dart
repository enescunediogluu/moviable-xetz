import 'package:flutter/material.dart';
import 'package:moviable/constants/colors.dart';
import 'package:moviable/services/auth_service.dart';
import 'package:moviable/services/database_service.dart';
import 'package:moviable/utils/text.dart';

class ListSettingsPage extends StatefulWidget {
  final String listId;
  final String listName;
  final String? listIcon;
  final String description;
  final bool private;
  const ListSettingsPage({
    super.key,
    required this.listId,
    required this.listName,
    required this.listIcon,
    required this.description,
    required this.private,
  });

  @override
  State<ListSettingsPage> createState() => _ListSettingsPageState();
}

class _ListSettingsPageState extends State<ListSettingsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final CustomListService database =
      CustomListService(AuthService().currentUser!.id);
  String profilePic = "";
  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    _nameController.text = widget.listName;
    _descriptionController.text = widget.description;

    profilePic = widget.listIcon!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  uploadProfilePhoto() async {
    setState(() {
      isLoading = true;
    });
    final tempUrl = await database.uploadProfilePhotoAndGetUrl();
    setState(() {
      profilePic = tempUrl;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Row(
            children: [
              SizedBox(
                width: 60,
              ),
              Icon(
                Icons.settings,
                color: primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              ModifiedText(
                text: 'Settings',
                color: sideColorWhite,
                size: 30,
              ),
            ],
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () async {
              if (profilePic == "") {
                uploadProfilePhoto();
              } else {
                await database.deleteImageFromFirebase(profilePic);
                uploadProfilePhoto();
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePic),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _nameController,
              cursorColor: primaryColor,
              decoration: textFieldInputDecoration('Name'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _descriptionController,
              cursorColor: primaryColor,
              decoration: textFieldInputDecoration('Description'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration textFieldInputDecoration(String labelName) {
    return InputDecoration(
        labelText: labelName,
        labelStyle: const TextStyle(
          color: primaryColor,
          fontSize: 17,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: sideColorGrey),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(15)));
  }
}
