import 'package:practical_test/presentation/blocs/home_screen/home_screen_bloc.dart';
import '../presentation/blocs/home_screen/home_screen_event.dart';

class StaticBody {
  void fetchCustomer(HomeScreenBloc bloc){
    bloc.add(FetchCustomerEvent({
      "user": {
        "UserName": "v",
        "Password": "v",
        "DeviceId": "355622080315528",
        "Active": true,
        "AppType": "Android",
        "FirstName": "Vinay",
        "Id": 3,
        "LastName": "Patel",
        "OrderCode": "VIE",
        "OrderCount": 1,
        "OrderPredictionCount": 1,
        "Role": "Driver"
      },
      "syncDate": "/Date(536436000-600)/",
      "pageIndex": 0,
      "appVersionNo": "1.0",
      "deviceDate": "/Date(536436000-600)/"
    }
    ));
  }

  void fetchCategory(HomeScreenBloc bloc){
    bloc.add(FetchCategoryEvent({
      "appVersionNo": "20240715.14",
      "deviceDate": "/Date(1721035961915+0530)/",
      "user": {
        "Active": true,
        "AppType": "Mobile",
        "DeviceId": "7f2226495640ecb1",
        "FirstName": "Vinay",
        "Id": 3,
        "IsResetSync": false,
        "LastName": "Emu",
        "OrderCode": "VIE",
        "OrderCount": 98,
        "OrderPredictionCount": 19,
        "Password": "v",
        "Role": "Driver",
        "UserName": "v"
      }
    }
    ));
  }


  void fetchProduct(HomeScreenBloc bloc){
    bloc.add(FetchProductEvent({
      "user": {
        "Active": true,
        "AppType": "Mobile",
        "DeviceId": "7f2226495640ecb1",
        "FirstName": "Vinay",
        "Id": 3,
        "IsResetSync": false,
        "LastName": "Emu",
        "OrderCode": "VIE",
        "OrderCount": 98,
        "OrderPredictionCount": 19,
        "Password": "v",
        "Role": "Driver",
        "UserName": "v"
      },
      "syncDate": "/Date(536436000-600)/",
      "pageIndex": 0,
      "appVersionNo": "1.0",
      "deviceDate": "/Date(1720768210-600)/"
    }
    ));
  }
}