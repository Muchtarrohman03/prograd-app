import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final double temperature;
  final String condition; // cerah, hujan, berawan, berangin, berkabut
  final String location;

  const WeatherWidget({
    super.key,
    required this.temperature,
    required this.condition,
    required this.location,
  });

  String _getWeatherAsset() {
    final text = condition.toLowerCase();

    if (text.contains('rain') || text.contains('hujan')) {
      return 'assets/images/weather/hujan.png';
    }
    if (text.contains('wind') || text.contains('angin')) {
      return 'assets/images/weather/berangin.png';
    }
    if (text.contains('cloud')) {
      return 'assets/images/weather/berawan.png';
    }
    if (text.contains('fog') ||
        text.contains('mist') ||
        text.contains('kabut')) {
      return 'assets/images/weather/berkabut.png';
    }

    return 'assets/images/weather/cerah.png';
  }

  String _formatCondition() {
    if (condition.contains('cloud')) return 'Berawan';
    if (condition.contains('rain')) return 'Hujan';
    if (condition.contains('wind')) return 'Berangin';
    if (condition.contains('fog') || condition.contains('mist')) {
      return 'Berkabut';
    }
    return 'Cerah';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: Colors.white.withOpacity(0.15),
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT: INFO CUACA
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCondition(),
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
          ),

          /// RIGHT: ICON CUACA
          Expanded(
            flex: 3,
            child: Image.asset(_getWeatherAsset(), fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
