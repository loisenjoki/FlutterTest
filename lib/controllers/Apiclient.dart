

import 'package:LearningFlutter/models/CountForm.dart';
import 'package:dio/dio.dart';

class Apiclient {

  Response response;
  Dio dio = new Dio();
  List <dynamic> catList = [] ;
  List  Countylist = const [];



  Future getCounties(String id)async{
    response = await dio.get("");
    Countylist = (response.data as List).map((e) => CountyForm.fromJson(e)).toList();
    print(Countylist);
    return Countylist;
  }



}