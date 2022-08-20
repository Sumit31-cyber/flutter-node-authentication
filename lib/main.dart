import 'package:flutter/material.dart';
import 'package:flutter_node_auth/Providers/user_provider.dart';
import 'package:flutter_node_auth/Screens/home_screen.dart';
import 'package:flutter_node_auth/Screens/signIn_screen.dart';
import 'package:flutter_node_auth/Screens/signup_screen.dart';
import 'package:flutter_node_auth/Services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? SignUpScreen()
          : HomeScreen(),
    );
  }
}
