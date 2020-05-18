import 'dart:convert';

import 'package:LearningFlutter/models/SubCat.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = new GlobalKey<FormState>();
  var _myActivity;
  var _myActivityResult;
  Response response;
  Dio dio = new Dio();
  var  listsub = const [];
  List  catList  = const [];


  //loading categories
 Future<dynamic> _getCategories() async {
   //note my json structure is [{id:1, name:"loise",age:"55"}]
    response = await dio.get("");
      catList =  response.data['subCategories'];
      List <SubCategories> subCategories = catList.map((json) => SubCategories.fromJson(json)).toList();
      print(catList);
      setState(() {
        listsub = subCategories;
      });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("Learning Flutter"),

      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                 child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: Colors.black26, style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButton<String>(
                    value: _myActivity,
                    iconSize: 30,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hint: Text('Choose...'),
                    onChanged: (String valuess) {
                      setState(() {
                        _myActivity = valuess;
                        print(_myActivity);
                      });
                    },
                    items: catList?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    })?.toList() ?? [],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
