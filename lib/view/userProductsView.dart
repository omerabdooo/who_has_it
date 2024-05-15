import 'package:flutter/material.dart';
import 'package:who_has_it/api/apiConnect.dart';
import 'package:who_has_it/models/crud.dart';
import 'package:who_has_it/view/creatUserProductView.dart';

import '../models/globalVariable.dart';

class userProductsView extends StatefulWidget {
  @override
  State<userProductsView> createState() => _userProductsViewState();
}

class _userProductsViewState extends State<userProductsView> {
  // model instance
  crud _crud = crud();

  getUserProducts() async {
    var response = await _crud.postRequest(getAllUserProducts, {
      "user_id": "$globalUserId" // here user_id
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              height: 155.0,
              color: Colors.indigo,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  // Username
                  Text(
                    "Hi $globalUserName",
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Add New Button
                  Container(
                    width: 125,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: TextButton(
                      onPressed: () {
                        // show add New User Product
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                  )),
                              height: MediaQuery.of(context).size.height - 170,
                              child: creatUserProductView(),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                    )),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: getUserProducts(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data["status"] == "fail") {
                          return const Center(
                            child: Text(
                              """You don`t have any products\n
                              please click ' Add New ' above\n
                              to add New product """,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: Colors.black54),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data["data"].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return 
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0 , left: 5.0, right: 5.0),
                              child: Container(
                                height: 90,
                                decoration: const BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(5.0)),
                                ),
                                child: ListTile(
                              
                                    leading: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage( 
                                          "$imageslink/${snapshot.data["data"][index]["product_image"]}",
                                          ),
                                    ),
                                   
                                    // Title 
                                    title: Text(
                                      '${snapshot.data["data"][index]["product_name"]}',
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    // Subtitle

                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        '${snapshot.data["data"][index]["product_description"]}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    // Trailing

                                    trailing: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, right: 5.0),
                                      child: Text(
                                        "${snapshot.data["data"][index]["product_price"]} \$ ",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )),
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Text("Loading ..."));
                      }

                      return const Center(child: Text("Loading ..."));
                    },
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}


