import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/presentation/screens/photo_list_screen.dart';

import '../cubit/theme_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // إخفاء شريط الحالة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // الانتقال للشاشة الرئيسية بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PhotoListScreen(),
      ),
    );
  }

  @override
  void dispose() {
    // إرجاع شريط الحالة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوجو Gallery
                Icon(
                  Icons.photo_library_rounded,
                  size: 80,
                  color: isDark ? Colors.white : Colors.black,
                ),

                const SizedBox(height: 20),

                // اسم التطبيق
                Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
