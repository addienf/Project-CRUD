// ignore_for_file: use_build_context_synchrously

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_w5/employee_model.dart';

import 'restapi.dart';

class EmployeeFormAdd extends StatefulWidget {
  const EmployeeFormAdd({Key? key}) : super(key: key);

  @override
  // ignone : libraty_private_type_in_public_api
  _EmployeeFormAddState createState() => _EmployeeFormAddState();
}

class _EmployeeFormAddState extends State<EmployeeFormAdd> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';

  late Future<DateTime?> selectedDate;
  String date = "-";

  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text("Employee From Add"),
          backgroundColor: Colors.indigo,
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
                  hintText: 'Birthday',
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
                  hintText: 'Phone Number',
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
                  hintText: 'Email Address',
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
                  hintText: 'Address',
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
                      List response = jsonDecode(await ds.insertEmployee(
                          '63476cf599b6c11c094bd5f3',
                          name.text,
                          phone.text,
                          email.text,
                          address.text,
                          gender,
                          birthday.text,
                          "-"));

                      List<EmployeeModel> employee = response
                          .map((e) => EmployeeModel.fromJson(e))
                          .toList();

                      if (employee.length == 1) {
                        Navigator.pop(context, true);
                      } else {
                        if (kDebugMode) {
                          print(response);
                        }
                      }
                    },
                    child: const Text("SUBMIT"),
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
