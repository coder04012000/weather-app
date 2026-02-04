import 'dart:convert';

import 'package:http/http.dart' as http;



class ApiServices {
  //var url = '';
  //
  // Future Post(String endpoin, data) async {
  //
  //   //
  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       body: data,
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': '*/*',
  //         // "access_token": access_token,
  //         // 'Authorization': 'Bearer $access_token',
  //         "Access-Control-Allow-Origin": "*",
  //       },
  //     );
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print("Error Occurred");
  //     print(e);
  //   }
  // }

  // get data from ---------------------

Future Home() async{
String url = 'https://api.openweathermap.org/data/2.5/weather?lat=26.2942&lon=81.8622&appid=178488549ffa0d3ae044d72879bbaa7f';
final response = await http.get(Uri.parse(url));
var responcedata = json.decode(response.body);
print(responcedata);
return responcedata;
}




}