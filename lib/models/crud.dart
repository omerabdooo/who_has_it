import 'dart:convert';
import 'dart:io';

// add to dependency 
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); // get the content of the body and change it from Json to Dart
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  // --------------

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); // get the content of the body and change it from Json to Dart
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  // function for upload the image file

postRequestImage(String url, Map data, File file) async{
  var request = http.MultipartRequest("POST", Uri.parse(url));

  var length = await file.length();
  var streem = http.ByteStream(file.openRead());

  var multipartFile = http.MultipartFile("product_image",streem,length,filename:basename(file.path) );

     // it is bring/take only the name of the file path
    // filename: basename(file.path),

    // add the image to the server
     request.files.add(multipartFile);

    //  this is for pass the data of the endpoint
     data.forEach((key, value) {
      request.fields[key] = value;
     });

     // send the request
     // now  myrequest is has a StreamedResponse data type
     var myrequest = await request.send();

     // get the response from the endpoint

     var response =await http.Response.fromStream(myrequest);

     if(myrequest.statusCode ==200) {

        return jsonDecode(response.body);

     }else{
      print("Erorr ${myrequest.statusCode}");
     }    
}

}


// ---------------------------------

// class user {
//   // final int id;
//   final String username;
//   final String password;


//   user({required this.username, required this.password});

//   factory user.fromJson(Map<String, dynamic> json) {
//     return user(
      
//       username: json["username"],
//       password: json["password"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'username': username,
//         "password": password,
//   };
// }



// ---------------

