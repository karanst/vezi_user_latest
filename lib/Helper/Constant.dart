import 'package:shared_preferences/shared_preferences.dart';

const String appName = 'Vezi';

const String packageName = 'com.vezi.user';
const String androidLink = "https://play.google.com/store/apps/details?id=com.vezi.user";
    //'https://play.google.com/store/apps/details?id=';

const String iosPackage = 'com.vezi.user';
const String iosLink = 'your ios link here';
const String appStoreId = '123456789';

const String deepLinkUrlPrefix = 'https://alpha.ecommerce.link';
const String deepLinkName = 'alpha.ecommerce.link';

const int timeOut = 100;
const int perPage = 10;
String razorPayKey="rzp_test_UUBtmcArqOLqIY";
String razorPaySecret="NTW3MUbXOtcwUrz5a4YCshqk";
// final String baseUrl = 'https://alphawizztest.tk/ENTEMARKET/app/v1/api/';
const String baseUrl = 'https://vezi.global/app/v1/api/';
const String imageUrl = 'https://vezi.global/';
const String jwtKey = "78084f1698c9fcff5a668b68dcd103db39be2605";
class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}