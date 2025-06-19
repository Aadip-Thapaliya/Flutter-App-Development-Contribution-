import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stockmarket/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Color> candleColors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.white,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StockHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEAEFE1), Color(0xFF7C9560)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ..._buildCircularDecorations(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'DIPPAY',
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    height: 1.0, // 100% of font size
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SvgPicture.asset(
                    'assets/svg/group Layer 1 (1).svg',
                    width: 40,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCircularDecorations() {
    final List<Offset> positions = [
      Offset(30, 50),
      Offset(300, 100),
      Offset(50, 500),
      Offset(200, 400),
      Offset(100, 650),
      Offset(250, 700),
    ];

    return positions.map((pos) {
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.3),
          ),
        ),
      );
    }).toList();
  }
}
