import 'package:flutter/material.dart';
import 'package:flutter_assignment2/view/main_screens/employee_page.dart';
import 'package:flutter_assignment2/view/main_screens/signin_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployeeDetailsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: signinPage(),
      ),
    );
  }
}
