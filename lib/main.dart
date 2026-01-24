import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'router/auth_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(); //⬅️ error pada baris ini
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthState()..load(),
      child: ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final authState = context.watch<AuthState>();

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter(authState),
          theme: ThemeData(
            fontFamily: 'BeVietnamPro',
            useMaterial3: true,
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.green,
              entryModeIconColor: Colors.green,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
        );
      },
    );
  }
}
