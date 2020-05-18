

import 'package:dio/dio.dart';

class Apiclient {

  Response response;
  Dio dio = new Dio();
  List <dynamic> catList = [] ;


  //loading categories
  Future getCategories() async {
    response = await dio.get("https://fainiapis.pro/sikika/v1/categories");
    catList = response.data['subCategories'];
    print(response.data['subCategories']);
    return catList;
  }
}