import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/confirm_button.dart';
import 'package:laravel_flutter/components/reusable/rounded_input_text.dart';
import 'package:laravel_flutter/router/auth_state.dart';
import 'package:laravel_flutter/services/api_service.dart';
import 'package:laravel_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({super.key});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> doLogin() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final auth = AuthService();
      final authState = context.read<AuthState>(); // 🔥 AMBIL STATE

      final response = await api.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final data = response["data"];

      final token = data?["access_token"];
      final username = data?["username"];
      final role = (data?["role"]?.isNotEmpty ?? false)
          ? data["role"][0]
          : null;

      if (token == null || role == null) {
        throw Exception("Data login tidak lengkap");
      }

      // 1️⃣ SIMPAN DATA LOGIN
      await auth.saveLoginData(token, username, role);

      // 2️⃣ UPDATE AUTH STATE (INI YANG PENTING)
      await authState.login(role);

      // ❌ TIDAK ADA context.go()
      // ❌ TIDAK ADA Navigator.push()
      // GoRouter akan redirect otomatis
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login gagal: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // penting untuk BottomSheet
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Masuk ke Akun Anda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  RoundedInputText(
                    hintText: "Masukkan Alamat Email",
                    controller: emailController,
                    labeldata: "Email",
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email wajib diisi";
                      }
                      if (!value.contains("@")) {
                        return "Email tidak valid";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  RoundedInputText(
                    hintText: "Masukkan Kata Sandi",
                    controller: passwordController,
                    labeldata: "Kata Sandi",
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ConfirmButton(
                    isLoading: isLoading,
                    action: doLogin,
                    text: "Masuk",
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
