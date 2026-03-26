// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/chat_controller.dart';
import 'controllers/contact_controller.dart';
import 'screens/main_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.bg,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const LocalBizApp());
}

class LocalBizApp extends StatelessWidget {
  const LocalBizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LocalBiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary:   AppColors.green,
          secondary: AppColors.mint,
          surface:   AppColors.bg2,
        ),
        fontFamily: 'sans-serif',
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(ChatController());
        Get.put(ContactController());
      }),
      home: const MainScreen(),
    );
  }
}
