import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppocket/components/button.dart';
import 'package:ppocket/constants/strings.dart';
import 'package:ppocket/views/group_spending_screen/group_spending.dart'; // Import GroupSpending screen

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String? category;
  final List<String> groupCategory = [
    'Trip',
    'Home',
    'Couple',
    'Others',
  ];
  final TextEditingController _groupNameController = TextEditingController();
  File? _image;

  // Method to open gallery and select an image
  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // Method to create a group
  void _createGroup(BuildContext context) {
    // Perform validation before creating the group
    if (_groupNameController.text.isEmpty || category == null) {
      // Show error Snackbar if any field is empty
      AppSnackBar.errorSnackbar(
        context,
        'Error',
        'Please fill all the fields',
      );
    } else {
      // Create the group
      Group newGroup = Group(
        name: _groupNameController.text,
        image: _image?.path ?? '', // Use image path if available
        type: category!,
      );

      // Show success Snackbar
      AppSnackBar.successSnackbar(context, 'Success', 'Group created successfully');

      // Navigate back to GroupSpending screen
      Navigator.pop(context, newGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          createGroup,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: OutlinedButton(
                    onPressed: _getImageFromGallery, // Open gallery when pressed
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Group Name:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _groupNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter group name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Add type selection dropdown here
            BuildDropDown(
              hint: 'Type',
              items: groupCategory,
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ButtonGreen(
                onPressed: () {
                  _createGroup(context); // Call method to create the group
                },
                text: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSnackBar {
  static void errorSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void successSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class BuildDropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function onChanged;

  const BuildDropDown({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BuildDropDown> createState() => _BuildDropDownState();
}

class _BuildDropDownState extends State<BuildDropDown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: widget.items.contains(selectedItem) ? selectedItem : null,
          onChanged: (value) {
            debugPrint('!!Selected item: $value');
            setState(() {
              selectedItem = value;
              widget.onChanged(value);
            });
          },
          items: widget.items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.category,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      e,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          )
              .toList(),
          selectedItemBuilder: (BuildContext context) => widget.items
              .map(
                (e) => Row(
              children: [
                // SizedBox(
                //   width: 42,
                //   child: Image.asset('images/$e.png'),
                // ),
                const SizedBox(width: 5),
                Text(e),
              ],
            ),
          )
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              widget.hint,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }
}
