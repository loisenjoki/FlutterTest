import 'dart:convert';

import 'package:LearningFlutter/controllers/Apiclient.dart';
import 'package:LearningFlutter/models/CountForm.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = new GlobalKey<FormState>();
  Response response;
  Dio dio = new Dio();
  List SubCatdescription = new List();
  List <CountyForm> CountiesList =  const [];
  Apiclient apiclient = new Apiclient();
  CountyForm selectedcounty;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("Learning Flutter"),

        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: <Widget>[
                  ]
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("County ", style:
                      TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800]
                      ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            //////////////********************************** Government Services Counties
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: Colors.black26, style: BorderStyle.solid, width: 0.80),
                                  ),
                                  child:new DropdownButton<CountyForm>(
                                    value: selectedcounty ,
                                    iconSize: 30,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    hint: Text('Choose...'),
                                    items: CountiesList?.map((CountyForm item) {
                                      return new DropdownMenuItem<CountyForm>(
                                        child: new Text(item.name),
                                        value: item,
                                      );
                                    })?.toList() ?? [],

                                    onChanged: ( CountyForm value) {
                                      setState(() {
                                        print(value.name);
                                        selectedcounty = value;
                                      });
                                    },

                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),

          ],
        )
    );

  }




}
