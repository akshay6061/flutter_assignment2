import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assignment2/view/main_screens/registration_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class employee_details extends StatefulWidget {
  const employee_details({super.key});
  @override
  State<employee_details> createState() => _employee_detailsState();
}

late EmployeeDetailsProvider detailsProvider;

DateTime _selectedDate = DateTime.now();

final List<String> genderOptions = ['Male', 'Female', 'Other'];
final List<String> maritalStatusOptions = [
  'Single',
  'Married',
  'Divorced',
  'Widowed'
];

class EmployeeDetails {
  String firstName = '';
  String lastName = '';
  DateTime dob = DateTime.now();
  String gender = 'Male';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String maritalStatus = 'Single';
}

class EmployeeDetailsProvider extends ChangeNotifier {
  EmployeeDetails _details = EmployeeDetails();

  EmployeeDetails get details => _details;

  void setDetails(EmployeeDetails details) {
    _details = details;
    notifyListeners();
  }
}

class _employee_detailsState extends State<employee_details> {
  File? _image;
  final picker = ImagePicker();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _loadImageFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final String? imagePath = _prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    if (_image != null) {
      await _prefs.setString('profile_image', imagePath);
    }
  }

  Future<void> getImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
        _saveImageToPrefs(PickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Widget build(BuildContext context) {
    var detailsProvider = Provider.of<EmployeeDetailsProvider>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text("Employee Details",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 10,
            ),
            _image != null
                ? Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(_image!),
                    ),
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/men profile.jpg'),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: getImage, child: Text("Select Image")),
            Divider(color: Colors.white, thickness: 3),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => detailsProvider.details.firstName = value,
                decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => detailsProvider.details.lastName = value,
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                width: 500,
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Select Date of Birth',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('DD/MM/YY'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                width: 500,
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select Gender',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: detailsProvider.details.gender,
                        onChanged: (value) {
                          setState(() {
                            detailsProvider.details.gender = value as String;
                          });
                        },
                        items: genderOptions.map((String gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        hint: Text(
                          'Select Gender',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                width: 500,
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Select Marital Status',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: detailsProvider.details.maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            detailsProvider.details.maritalStatus =
                                value as String;
                          });
                        },
                        items: maritalStatusOptions.map((String status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        hint: Text('Select Marital Status'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => detailsProvider.details.email = value,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) =>
                    detailsProvider.details.phoneNumber = value,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => detailsProvider.details.address = value,
                decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => registration()),
                );
              },
              child: Text('Save'),
            ),
          ]),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        detailsProvider.details.dob = pickedDate;
      });
    }
  }
}
