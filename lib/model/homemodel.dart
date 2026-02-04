import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Apiservices/apiservieses.dart';


class HomePageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _data = [];
  bool isLoading = false;
  String _status = '';
  String _responsedata = '';
  var apiObj = ApiServices();

  get progress => isLoading;
  get status => _status;
  get message => _responsedata;

  List<Map<String, dynamic>> get data => _data;

  set data(newData) {
    _data = newData;
    notifyListeners();
  }

  Future<void> getdata() async {
    isLoading = true;
    notifyListeners(); // Notify listeners that loading is in progress

    final res = await apiObj.Home();
//print(res);
    if (res != null) {
      _responsedata = "Data loaded successfully";
      var listData = res;
//print(listData);
      _data.clear(); // Clear previous data
      //
      // listData.forEach((elements) {
      //   //    print(elements);
      //   _data.add({
      //     "id": elements['userId'].toString(),
      //     "userName": elements['id'].toString(),
      //     "location": elements['title'].toString(),
      //
      //   });
      // });
    }
    else {
      _responsedata = res['message'];
      _status = res['status'].toString();
    }

    isLoading = false;
    notifyListeners(); // Notify listeners after data has been updated
  }
}
