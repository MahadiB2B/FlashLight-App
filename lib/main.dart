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

  // ক্যামেরা ইনিশিয়ালাইজেশন
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

    // স্লাইডার ০.২ এর নিচে গেলে টর্চ অফ হবে, উপরে থাকলে অন হবে
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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Flashlight Controller'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !_isCameraReady
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Brightness: ${(_brightnessLevel * 100).round()}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isTorchOn ? Colors.amber : Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // পাওয়ার বাটন
            GestureDetector(
              onTap: () => _toggleTorch(!_isTorchOn),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isTorchOn
                      ? Colors.amber.shade600
                      : Colors.grey.shade900,
                  boxShadow: _isTorchOn
                      ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.6),
                      blurRadius: 40,
                      spreadRadius: 10,
                    )
                  ]
                      : [],
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  size: 70,
                  color: _isTorchOn ? Colors.black : Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // ব্রাইটনেস স্লাইডার
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.highlight, color: Colors.grey, size: 20),
                      Icon(Icons.wb_sunny_rounded,
                          color: Colors.amber, size: 28),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.amber,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: Colors.amberAccent,
                      overlayColor: Colors.amber.withOpacity(0.2),
                      trackHeight: 8.0,
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
      ),
    );
  }
}