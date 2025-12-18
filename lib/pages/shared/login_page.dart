import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/part/auth_bottom_sheet.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(200, 230, 201, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang👋",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Buat laporan pekerjaan, sekarang jadi lebih mudah !",
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
              ),
              const SizedBox(height: 20),

              // Pastikan gambar tersedia di assets
              Center(
                child: Image.asset(
                  "assets/images/ilustration1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomSheet: const AuthBottomSheet(),
    );
  }
}
