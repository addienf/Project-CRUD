import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_w5/employee_model.dart';

import 'restapi.dart';

class EmployeeFromEdit extends StatefulWidget {
  const EmployeeFromEdit({Key? key}) : super(key: key);

  @override
  _EmployeeFormEditState createState() => _EmployeeFormEditState();
}

class _EmployeeFormEditState extends State<EmployeeFromEdit> {
  DataService ds = DataService();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';
  String update_id = '';

  late Future<DateTime?> selectedDate;
  String date = "-";

  //Employee Data
  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectAll('63476b5c99b6c11c094bd512', 'office',
        'employee', '63476cf599b6c11c094bd5f3'));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    name.text = employee[0].name;
    birthday.text = employee[0].birthday;
    phone.text = employee[0].phone;
    email.text = employee[0].email;
    address.text = employee[0].address;
    gender = employee[0].gender;
    update_id = employee[0].id;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    selectIdEmployee(args[0]);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text("Employee From Edit"),
          //backgroundColor: Colors.indigo,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                ),
              ),
            ),
            //Gender
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                    ),
                    value: gender,
                    onChanged: (String? newValue) {
                      if (kDebugMode) {
                        print(newValue);
                      }

                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: <String>['Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList())),
            // Birthday
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Birthday",
                ),
                onTap: () {
                  showDialogPicker(context);
                },
              ),
            ),
            // Phone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Phone Number",
                ),
              ),
            ),
            // Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email Address",
                ),
              ),
            ),
            // Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: address,
                maxLines: 4,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Address",
                ),
              ),
            ),
            // Submit Button
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen, elevation: 0),
                    onPressed: () async {
                      bool updateStatus = await ds.updateId(
                          'name~email',
                          '${name.text}~${email.text}',
                          '63476b5c99b6c11c094bd512',
                          'office',
                          'employee',
                          '63476cf599b6c11c094bd5f3',
                          update_id);

                      if (updateStatus) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text("UPDATE"),
                  ),
                ))
          ],
        ));
  }

  // Date Picker
  void showDialogPicker(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        final DateFormat formater = DateFormat('dd-MM-yyyy');
        final String formattedDate = formater.format(value);
        birthday.text = formattedDate;
      });
    }, onError: (Error) {
      if (kDebugMode) {
        print(Error);
      }
    });
  }
}
