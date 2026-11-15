import 'package:flutter/material.dart';
import 'models/item_model.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'utils/helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final items = await StorageService.loadItems();
  runApp(ExpireMateApp(initialItems: items));
}

class ExpireMateApp extends StatelessWidget {
  const ExpireMateApp({super.key, required this.initialItems});
  final List<ExpiryItem> initialItems;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExpireMate',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kDarkGreen,
          primary: kDarkGreen,
          surface: kCream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kCream,
          foregroundColor: kDarkText,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: kWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: kCardBorder, width: 1.2),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: kCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kWhite,
          labelStyle: const TextStyle(color: kSubText, fontSize: 13),
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: kCardBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: kDarkGreen, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.8),
          ),
        ),
      ),
      home: SplashScreen(initialItems: initialItems),
    );
  }
}
