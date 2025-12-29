import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/icon_label_button.dart';
import 'package:laravel_flutter/components/reusable/weather_widget.dart';
import 'package:laravel_flutter/components/reusable/welcome_appbar.dart';
import 'package:laravel_flutter/services/auth_service.dart';
import 'package:laravel_flutter/services/location_service.dart';
import 'package:laravel_flutter/services/weather_service.dart';

class GardenerHomePage extends StatefulWidget {
  const GardenerHomePage({super.key});

  @override
  State<GardenerHomePage> createState() => _GardenerHomePageState();
}

class _GardenerHomePageState extends State<GardenerHomePage> {
  final storage = FlutterSecureStorage();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  bool isLoadingWeather = true;
  String? city;
  double? temperature;
  String? description;

  String username = "";
  String role = "";

  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadWeatherByLocation();
    loadUserInfo();
  }

  Future<void> _loadWeatherByLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final data = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        city = data['name'];
        temperature = (data['main']['temp'] as num).toDouble();
        description = data['weather'][0]['description'];
        isLoadingWeather = false;
      });
    } catch (e) {
      debugPrint("WEATHER ERROR: $e");
      setState(() => isLoadingWeather = false);
    }
  }

  Future<void> loadUserInfo() async {
    final u = await storage.read(key: 'username') ?? '';
    final r = await storage.read(key: 'role') ?? '';

    if (!mounted) return; // ⬅️ INI WAJIB

    setState(() {
      username = u;
      role = r;
      role = role[0].toUpperCase() + role.substring(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.green[500],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: WelcomeAppbar(name: username.isNotEmpty ? username : 'Pengguna'),
      ),
      body: CustomScrollView(
        slivers: [
          //HEADER ATAS
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang, $role",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// 🌦️ WEATHER SECTION
                  if (isLoadingWeather)
                    const Text(
                      "Memuat data cuaca...",
                      style: TextStyle(color: Colors.white70),
                    )
                  else if (temperature != null &&
                      description != null &&
                      city != null)
                    WeatherWidget(
                      temperature: temperature!,
                      condition: description!,
                      location: city!,
                    )
                  else
                    const Text(
                      "Gagal memuat data cuaca.",
                      style: TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),
          ),

          //BODY (PUTIH, ROUNDED)
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Menu",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconLabelButton(
                                icon: HeroIcons.clipboardDocumentCheck,
                                containercolor: Colors.blue.shade100,
                                iconcolor: Colors.blue.shade300,
                                label: "Pekerjaan\nBaru",
                                onPressed: () {
                                  // Aksi ketika tombol ditekan
                                  context.push('/gardener/job-submission');
                                },
                              ),
                              IconLabelButton(
                                icon: HeroIcons.clock,
                                containercolor: Colors.green.shade100,
                                iconcolor: Colors.green.shade300,
                                label: "Pengajuan\nLembur",
                                onPressed: () {
                                  // Aksi ketika tombol ditekan
                                  context.push('/gardener/create-overtime');
                                },
                              ),
                              IconLabelButton(
                                icon: HeroIcons.calendarDateRange,
                                containercolor: Colors.orange.shade100,
                                iconcolor: Colors.orange.shade300,
                                label: "Laporan\nIzin",
                                onPressed: () {
                                  // Aksi ketika tombol ditekan
                                  context.push('/gardener/create-absence');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    //TAMBAHKAN KONTEN PANJANG
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (_, i) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: HeroIcon(
                              HeroIcons.documentText,
                              style: HeroIconStyle.solid,
                              color: Colors.green.shade300,
                            ),
                          ),
                          title: Text('Item $i'),
                          subtitle: Text('Deskripsi item ke-$i'),
                          trailing: const HeroIcon(HeroIcons.chevronRight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
