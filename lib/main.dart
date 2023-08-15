import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zzsports/pages/main_page.dart';
import 'package:zzsports/service/http_service.dart';
import 'ble/ble_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initServices();
  runApp(const MyApp());
}

initServices() async {
  BleManager();
  await Get.putAsync<HttpService>(
          () async => await HttpService().init(baseUrl: "http://www.xueyazhushou.com"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: MainPage());
  }
}