import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } catch (e) {
    debugPrint("Camera Error: $e");
  }
  runApp(const FlashlightApp());
}

class FlashlightApp extends StatelessWidget {
  const FlashlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FlashlightScreen(),
    );
  }
}

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  CameraController? _controller;
  bool _isTorchOn = false;
  double _brightnessLevel = 1.0;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // ক্যামেরা ইনিশিয়ালাইজেশন
  Future<void> _initCamera() async {
    if (_cameras.isEmpty) return;

    final backCamera = _cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      debugPrint("Controller init failed: $e");
    }
  }

  // টর্চ অন/অফ করার মূল কাজ
  Future<void> _toggleTorch(bool turnOn) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (turnOn) {
        await _controller!.setFlashMode(FlashMode.torch);
        if (mounted) {
          setState(() {
            _isTorchOn = true;
          });
        }
      } else {
        await _controller!.setFlashMode(FlashMode.off);
        if (mounted) {
          setState(() {
            _isTorchOn = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Torch error: $e");
    }
  }

  // স্লাইডার কন্ট্রোল
  void _onSliderChanged(double value) {
    setState(() {
      _brightnessLevel = value;
    });

    if (value <= 0.2 && _isTorchOn) {
      _toggleTorch(false);
    } else if (value > 0.2 && !_isTorchOn) {
      _toggleTorch(true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('Flashlight'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !_isCameraReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ব্রাইটনেস স্ট্যাটাস টেক্সট
          Text(
            'Brightness: ${(_brightnessLevel * 100).round()}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _isTorchOn ? Colors.amber : Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // ছবির আদলে তৈরি রিয়ালিস্টিক টর্চলাইট ডিজাইন
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // টর্চের মাথা (Head অংশ - রিং সহ)
                      Container(
                        width: 170,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2c2c2c),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(25),
                            bottom: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isTorchOn
                                  ? Colors.amber.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.6),
                              blurRadius: _isTorchOn ? 45 : 12,
                              spreadRadius: _isTorchOn ? 12 : 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            // সিলভার রিং বা বর্ডার
                            Container(
                              width: 150,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // টর্চের নিচের বডি অংশ
                      Container(
                        width: 130,
                        height: 240,
                        decoration: const BoxDecoration(
                          color: Color(0xFF202020),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(35),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ঠিক মাঝখানের পাওয়ার সুইচ বাটন
                  Positioned(
                    child: GestureDetector(
                      onTap: () => _toggleTorch(!_isTorchOn),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isTorchOn
                              ? Colors.amber.shade600
                              : const Color(0xFF141414),
                          border: Border.all(
                            color: _isTorchOn
                                ? Colors.amberAccent
                                : Colors.grey.shade800,
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isTorchOn
                                  ? Colors.amber.withValues(alpha: 0.6)
                                  : Colors.black.withValues(alpha: 0.9),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.power_settings_new_rounded,
                          size: 36,
                          color: _isTorchOn
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // নিচে ব্রাইটনেস স্লাইডার
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 40.0, vertical: 30.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.highlight, color: Colors.grey, size: 20),
                    Icon(Icons.wb_sunny_rounded,
                        color: Colors.amber, size: 26),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.amber,
                    inactiveTrackColor: Colors.grey.shade800,
                    thumbColor: Colors.amberAccent,
                    overlayColor: Colors.amber.withValues(alpha: 0.2),
                    trackHeight: 6.0,
                  ),
                  child: Slider(
                    value: _brightnessLevel,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (value) => _onSliderChanged(value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}