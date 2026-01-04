// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/theme_provider.dart';
// import 'providers/goal_provider.dart';
// import 'providers/user_provider.dart';
// import 'theme/app_theme.dart';
// import 'screens/splash_screen.dart';
// import 'package:appwrite/appwrite.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Appwrite client
//   Client client = Client()
//       .setEndpoint('https://fra.cloud.appwrite.io/v1') // Your endpoint
//       .setProject("6925edab00138e958282");          // Your project ID

//   Account account = Account(client);

//   runApp(MyApp(account: account));
// }

// class MyApp extends StatelessWidget {
//   final Account account;

//   const MyApp({super.key, required this.account}); // Fixed constructor

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => GoalProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()), // Pass account to user provider if needed
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             title: 'GoalMate',
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.lightTheme,
//             home: const SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/theme_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'GoalMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

