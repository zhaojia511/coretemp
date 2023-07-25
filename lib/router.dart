import 'package:go_router/go_router.dart';
import 'package:zzsports/pages/device_page.dart';
import 'package:zzsports/pages/my_page.dart';
import 'pages/main_page.dart';
import 'pages/detail.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/',
    builder: (context, state) => MainPage(),
  ),
  GoRoute(path: '/detail/:id',
    builder: (context, state) => DetailPage(itemId: state.pathParameters['id']!),
  ),
  GoRoute(path: '/device',
    builder: (context, state) => DevicePage(),
  ),
  GoRoute(path: '/my',
    builder: (context, state) => MyPage(),
  ),
]);

