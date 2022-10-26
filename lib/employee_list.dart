import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_w5/employee_model.dart';

import 'restapi.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  DataService ds = DataService();

  List data = [];
  List<EmployeeModel> employee = [];

  SelectAllEmployee() async {
    data = jsonDecode(await ds.selectAll('63476b5c99b6c11c094bd512', 'office',
        'employee', '63476cf599b6c11c094bd5f3'));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    setState(() {
      employee = employee;
    });
  }

  //Reload depend on navigator
  FutureOr reloadDataEmployee(dynamic value) {
    setState(() {
      SelectAllEmployee();
    });
  }

  @override
  void initState() {
    SelectAllEmployee();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee List"),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'employee_form_add')
                      .then((reloadDataEmployee));
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          final item = employee[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.birthday),
            onTap: () {
              Navigator.pushNamed(context, 'employee_detail',
                  arguments: [item.id]).then(reloadDataEmployee);
            },
          );
        },
      ),
    );
  }
}
