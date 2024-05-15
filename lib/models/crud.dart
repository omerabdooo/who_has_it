import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); 
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
            .body); 
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

  // MultipartRequest make us able to send photos and videos and texts , not only texts
  var request = http.MultipartRequest("POST", Uri.parse(url));

  // the size of the file
  var length = await file.length();

  // seprate the file into multiple binary data 
  var streem = http.ByteStream(file.openRead());

//   تمثيل ملف يتم إرساله إلى خادم الويب
// توفير معلومات حول الملف، مثل اسمه وحجمه ونوعه
// الوصول إلى محتويات الملف (في بعض الحالات)

  var multipartFile = http.MultipartFile("product_image",streem,length,filename:basename(file.path) );

     // it is bring/take only the name of the file path
    // filename: basename(file.path),

    // add the information of the image that in multipartFile  to MultipartRequest 
    // the word request is a variable we declrate it above
     request.files.add(multipartFile);

    //  this is for pass the data of the endpoint
    // we declare the word data above as a parameter of the postRequestImage function that we are in it now
     data.forEach((key, value) {
      request.fields[key] = value;
     });

     // send the request
     // now  myrequest is has a StreamedResponse data type
     var myrequest = await request.send();

     // get the response from the endpoint

     var response =await http.Response.fromStream(myrequest);

     if(myrequest.statusCode ==200) {
print(response.body);
        return jsonDecode(response.body);

     }else{
      print("Erorr ${myrequest.statusCode}");
     }    
}

}


// ---------------------------------
