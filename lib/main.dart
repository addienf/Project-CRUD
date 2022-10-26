import 'package:flutter/material.dart';
import 'package:flutter_application_w5/employee_detail.dart';

import 'package:flutter_application_w5/employee_form_edit.dart';
import 'package:flutter_application_w5/employee_form_add.dart';
import 'package:flutter_application_w5/employee_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const EmployeeList(),
      routes: {
        'employee_list': (context) => const EmployeeList(),
        'employee_form_add': (context) => const EmployeeFormAdd(),
        'employee_form_edit': (context) => const EmployeeFromEdit(),
        'employee_detail': (context) => const EmployeeDetail()
      },
    );
  }
}
