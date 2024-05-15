import 'package:flutter/material.dart';
import 'package:who_has_it/models/globalVariable.dart';
import 'package:who_has_it/view/singUpView.dart';
import 'package:who_has_it/view/userProductsView.dart';
// import 'package:http/http.dart' as http;

import '../api/apiConnect.dart';
import '../models/crud.dart';

class loginView extends StatefulWidget {
  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {

  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  // model instant
  final crud _crud = crud();

// endpoint getUser logic
  getUser() async {
    var response = await _crud.postRequest(getUserrApi, {
      "user_email": emailController.text,
      "user_password": passwordController.text
    });
    if (response["status"] == "success") {

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userProductsView()));

      print(response);

      globalUserId = response["data"][0]["user_id"];
      globalUserName = response["data"][0]["user_username"];
    } 
    else {
      print("faield");
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Login to your account",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),

                const SizedBox(
                  height: 26,
                ),

                // Email Text Field
                Material(
                  elevation: 6.0,
                  shadowColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorText: emailValidator(emailController.text),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                ),

                const SizedBox(height: 20.0),

                // Password Text Field
                Material(
                  elevation: 6.0,
                  shadowColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorText: passwordValidator(passwordController.text),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Sign In Button
                ElevatedButton(
                  onPressed: () async {
                    if (emailValidator(emailController.text) == null &&
                        passwordValidator(passwordController.text) == null) {
                      await getUser();
                    } else {
                      print(emailValidator(emailController.text));
                      print(passwordValidator(passwordController.text));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 6.0,
                    shadowColor: Colors.grey[300],
                    fixedSize: const Size(200, 58),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Don't have an account text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black45),
                    ),
                    TextButton(
                      onPressed: () {
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => singUpView()));
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// validator method
  String? emailValidator(String email) {
    final RegExp emailPattern =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$');

    if (!emailPattern.hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? passwordValidator(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
