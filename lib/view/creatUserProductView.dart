import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:who_has_it/models/globalVariable.dart';
import 'package:who_has_it/models/crud.dart';
import 'package:who_has_it/view/userProductsView.dart';

import '../api/apiConnect.dart';

class creatUserProductView extends StatefulWidget {
  @override
  State<creatUserProductView> createState() => _creatUserProductViewState();
}

class _creatUserProductViewState extends State<creatUserProductView> {
  // for using it with the image

  File? myfile;

  // controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final priceController = TextEditingController();

  // model instance
  final crud _crud = crud();

  createUserProducts() async {
    // this is for validate that the image is not null
    // if (myfile== null) return

    var response = await _crud.postRequestImage(
        createUserProduct,
        {
          "product_name": nameController.text,
          "product_description": descriptionController.text,
          // "product_image": "",
          "product_price": priceController.text,

          "user_product": "$globalUserId"
        },
        myfile!);

    print(response);
    if (response["status"] == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => userProductsView()),
        ModalRoute.withName('/'),
      );
    } else {
      print("Sing up Failed");
      print(response);
    }
  }

  // createUserproduct endpoint (work without image send)

  // createUserProducts() async {
  //   var response = await _crud.postRequest(createUserProduct, {

  //     "product_name": nameController.text,
  //     "product_description": descriptionController.text,
  //     "product_image": "",
  //     "product_price": priceController.text,
  //     "user_product": "$globalUserId"
  //   });
  //   print(response);
  //   if (response["status"] == 'success') {

  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => userProductsView()),
  //       ModalRoute.withName('/'),
  //     );
  //   }
  //   // else {
  //   //   print("Sing up Failed");
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product to your Products'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Create a new product",
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
                      labelText: 'product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorText: nameValidator(nameController.text),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // description Text Field
                Material(
                  elevation: 6.0,
                  shadowColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: ' product description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorText:
                          descriptionValidator(descriptionController.text),
                    ),
                    autocorrect: false,
                  ),
                ),

                const SizedBox(height: 20.0),

                // price Text Field
                Material(
                  elevation: 6.0,
                  shadowColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'product price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // errorText: priceValidator(priceController.text),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                const SizedBox(height: 20.0),

                // add image

                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: InkWell(
                          // the logic of adding an image

                          onTap: () async {
                            XFile? xfile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            // we declare the variable ' myfile ' above in the beging
                            // and use it in the postRequestImage parameter
                            myfile = File(xfile!.path);
                            Navigator.of(context).pop();
                          },

                          child: Text(
                            "choose image from Gallery",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text("choose image"),
                ),

                const SizedBox(height: 20.0),

                // Create product Button

                ElevatedButton(
                  onPressed: () async {
                    if (nameValidator(nameController.text) == null &&
                        descriptionValidator(descriptionController.text) ==null
                        // priceValidator(priceController.text) == null
                        )
                        {
                          await createUserProducts();
                        }
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
                    'Create',
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
                      'Dont want to create product?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                          fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Click Close',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
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
    if (name.length < 3 || name.length > 20) {
      return "Password must be at more than 2 and less than 20 characters long";
    }
    return null;
  }

  String? descriptionValidator(String description) {
    if (description.length < 2 || description.length > 30) {
      return "Password must be at more than 2 and less than 20 characters long";
    }
    return null;
  }

  // String? priceValidator(int price) {
  //   if ( int num == false) {
  //     return "the price must be numbers";
  //   } else {
  //     return null;
  //   }
  // }
}
