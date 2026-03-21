import 'dart:async';
import 'package:e_commarce_admin/auth_checker/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  double progress = 0;

  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final Color gold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();

    /// 🔥 Pulse Animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    /// 🔥 Fade + Scale
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack);

    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _fadeController.forward();

    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 1.5;
      });

      if (progress >= 100) {
        timer.cancel();
        Get.offAll(const AuthChecker());
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A1F44),
              Color(0xFF06142E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// 🔝 TOP
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    "SECURE TERMINAL • NODE 01",
                    style: TextStyle(
                      color: gold.withOpacity(0.6),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              /// 🔥 CENTER
              Column(
                children: [

                  /// 🔥 PULSE RING EFFECT
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [

                          /// OUTER RING
                          Container(
                            width: 160 + (_pulseController.value * 20),
                            height: 160 + (_pulseController.value * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: gold.withOpacity(
                                    0.2 - (_pulseController.value * 0.2)),
                                width: 2,
                              ),
                            ),
                          ),

                          /// INNER CIRCLE
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  "VR",
                                  style: TextStyle(
                                    color: gold,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Text(
                          "VASTRA\nROYALE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: gold,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "PREMIUM ADMIN",
                          style: TextStyle(
                            color: gold.withOpacity(0.7),
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// 🔽 BOTTOM
              Column(
                children: [

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      "INITIALIZING... ${progress.toInt()}%",
                      style: TextStyle(
                        color: gold.withOpacity(0.7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.white10,
                      color: gold,
                      minHeight: 4,
                    ),
                  ),

                  const SizedBox(height: 30),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: gold.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "🔒 AUTHORIZED PERSONNEL ONLY",
                        style: TextStyle(
                          color: gold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "© 2026 VASTRA ROYALE",
                    style: TextStyle(
                      color: gold.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}