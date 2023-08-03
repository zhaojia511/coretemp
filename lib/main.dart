import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zzsports/pages/main_page.dart';
import 'package:zzsports/service/http_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initServices();
  runApp(const MyApp());
}

initServices() async {
  await Get.putAsync<HttpService>(
          () async => await HttpService().init(baseUrl: "http://www.xueyazhushou.com"));
  Get.put(FlutterReactiveBle());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: MainPage());
  }
}