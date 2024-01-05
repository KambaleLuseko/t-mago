import 'Resources/Constants/global_variables.dart';
import 'Resources/Providers/app_state_provider.dart';
import 'Resources/Providers/cultivator.provider.dart';
import 'Resources/Providers/fields.provider.dart';
import 'Resources/Providers/humidity.provider.dart';
import 'Resources/Providers/menu_provider.dart';
import 'Resources/Providers/sync.provider.dart';
import 'Resources/Providers/users_provider.dart';
import 'Views/login.dart';
import 'Views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/Providers/mouvement.provider.dart';

List storeNames = ['cultivators', 'fields', 'mouvements', 'users', 'humidites'];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  runApp(const MyApp());
}

late SharedPreferences prefs;
GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
String appName = "Entrepot";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => HumidityPricesProvider()),
        ChangeNotifierProvider(create: (_) => CultivatorProvider()),
        ChangeNotifierProvider(create: (_) => FieldsProvider()),
        ChangeNotifierProvider(create: (_) => MouvementProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.kScaffoldColor,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.kPrimaryColor),
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navKey,
        home: prefs.getString('loggedUser') != null
            ? const MainPage()
            : LoginPage(),
      ),
    );
  }
}
