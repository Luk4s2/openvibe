import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/di/di.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';


/// Entry point of the Openvibe application.
void main() {
  initDependencies();
  runApp(const MyApp());
}

/// Root widget of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
    );
  }
}
