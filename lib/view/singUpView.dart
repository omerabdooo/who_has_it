import 'package:flutter/material.dart';
import 'package:who_has_it/models/crud.dart';
import 'package:who_has_it/view/loginView.dart';

import '../api/apiConnect.dart';

class singUpView extends StatefulWidget {
  @override
  State<singUpView> createState() => _singUpViewState();
}

class _singUpViewState extends State<singUpView> {
  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // model instance
  final crud _crud = crud();

  // createUser endpoint

  createUser() async {
    var response = await _crud.postRequest(creatUserApi, {
      "user_username": nameController.text,
      "user_email": emailController.text,
      "user_password": passwordController.text
    });
    // print(response);
    if (response["status"] == 'success') {

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } 
    // else {
    //   print("Sing up Failed");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Screen',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Create a new account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 26.0),

                // Name Text Field
                Material(
                  elevation: 6.0,
                  shadowColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorText: nameValidator(nameController.text),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

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
                SizedBox(height: 20.0),

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

                // Sign Up Button

                ElevatedButton(
                  onPressed: () async {
                    if (nameValidator(nameController.text) == null &&
                        emailValidator(emailController.text) == null &&
                        passwordValidator(passwordController.text) == null) {
                      await createUser();
                    }
                    //  else {
                    //   print("falied");
                    //   print(nameValidator(nameController.text));
                    //   print(passwordValidator(passwordController.text));
                    //   print(emailValidator(emailController.text));
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 6.0,
                    shadowColor: Colors.grey[300],
                    fixedSize: Size(200, 58),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginView()));
                      },
                      child: const Text('Sign In'),
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

  // validator methods

  String? nameValidator(String name) {
    if (name.isEmpty || name.length < 2) {
      return 'Name Required To Be More Than Two Characthers ';
    }
    return null;
  }
}

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
