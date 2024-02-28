import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DualCameraScreen extends StatefulWidget {
  @override
  _DualCameraScreenState createState() => _DualCameraScreenState();
}

class _DualCameraScreenState extends State<DualCameraScreen> {
  CameraController? _backCameraController;
  CameraController? _frontCameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();

    _backCameraController = CameraController(
      _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      ),
      ResolutionPreset.medium,
    );

    _frontCameraController = CameraController(
      _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.medium,
    );

    await _backCameraController!.initialize();
    await _frontCameraController!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _backCameraController?.dispose();
    _frontCameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_backCameraController == null ||
        _frontCameraController == null ||
        !_backCameraController!.value.isInitialized ||
        !_frontCameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraPreview(_backCameraController!),
          ),
          Expanded(
            child: CameraPreview(_frontCameraController!),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: DualCameraScreen()));
