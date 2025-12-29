import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'router/auth_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthState()..load(),
      child: const MyApp(),
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
          theme: ThemeData(fontFamily: 'BeVietnamPro', useMaterial3: true),
        );
      },
    );
  }
}
