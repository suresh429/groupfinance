import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:groupfinance/app/modules/home/bindings/home_binding.dart';

import 'app/modules/home/controllers/group_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await Future.delayed(const Duration(seconds: 1))
      .then((value) => FlutterNativeSplash.remove());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Group Finance",
      initialRoute: AppPages.INITIAL,
      initialBinding: HomeBinding(),
      getPages: AppPages.routes,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        hintColor: Colors.yellow,
        primaryColor: const Color(0xff141A31),
        primaryColorDark: const Color(0xff081029),
        scaffoldBackgroundColor: const Color(0xff141A31),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.yellow),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
          ),
        ),
      ),
    ),
  );
}
