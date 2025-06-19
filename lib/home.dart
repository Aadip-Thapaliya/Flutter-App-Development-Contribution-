import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StockHomePage extends StatefulWidget {
  const StockHomePage({super.key});

  @override
  State<StockHomePage> createState() => _StockHomePageState();
}

class _StockHomePageState extends State<StockHomePage> {
  final _svgCache = <String, String>{};

  Future<String?> _loadSvg(String path) async {
    try {
      if (_svgCache.containsKey(path)) {
        return _svgCache[path];
      }

      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final svgString = utf8.decode(bytes);

      _svgCache[path] = svgString;
      return svgString;
    } catch (e) {
      debugPrint('Error loading SVG: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Top Portfolio Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0xFFFE5762), Color(0xFFFF6BA1)],
                    stops: [0.4947, 0.9575],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your total asset portfolio',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$ 2.240.559',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_upward,
                          size: 16,
                          color: Colors.white,
                        ),
                        Text(
                          '+2%',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // What’s to Buy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "What's to Buy?",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 28 / 22, // line height = line-height / font-size
                      letterSpacing: 0.8,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        'See All',
                        textAlign: TextAlign.right, // Align text to the right
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height:
                              28 / 18, // line height = 28px / 18px font size
                          letterSpacing: 0.8,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_rounded, color: Colors.pink),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildStockCard(
                      'AAPL',
                      '\$364.11',
                      Colors.black,
                      'assets/svg/Figma Logo.png',
                    ),
                    buildStockCard(
                      'MCD',
                      '\$183.52',
                      Colors.redAccent,
                      'assets/svg/Logo (1).png',
                    ),
                    buildStockCard(
                      'FB',
                      '\$233.42',
                      Colors.blue,
                      'assets/svg/Logo (2).png',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Today’s Opinion
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1C28),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Today's Opinion",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(Icons.close, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildOpinionTile(
                      'Most Valuable Stocks 2020',
                      'This is how you set your foot for 2020 Stock market recession. What’s next...',
                      'assets/svg/Frame 3 from Figma.png',
                    ),
                    buildOpinionTile(
                      'How To Pick for a Blue Chip',
                      'What do you like to see? It’s a very different market from 2018. The way...',
                      'assets/svg/Frame 3.png',
                    ),
                    buildOpinionTile(
                      'Welcome to New NASDAQ',
                      'When we talk about the wall street, what looks good might be different',
                      'assets/svg/Frame 3 from Figma (1).png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStockCard(
    String title,
    String price,
    Color bgColor,
    String svgAssetPath,
  ) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(svgAssetPath, width: 24, height: 24),
            // SvgPicture.asset(svgAssetPath, width: 24, height: 24),
            const SizedBox(height: 10),
            Column(
              children: [
                Center(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    price,
                    style: GoogleFonts.inter(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOpinionTile(String title, String subtitle, String assetPath) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(assetPath, width: 24, height: 24),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}
