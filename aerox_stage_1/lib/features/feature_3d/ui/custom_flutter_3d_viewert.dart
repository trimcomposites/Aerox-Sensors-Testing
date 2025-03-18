import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/src/controllers/flutter_3d_controller.dart';
import 'package:flutter_3d_controller/src/core/modules/obj_viewer/obj_viewer.dart';
import 'package:flutter_3d_controller/src/data/datasources/i_flutter_3d_datasource.dart';
import 'package:flutter_3d_controller/src/data/repositories/flutter_3d_repository.dart';
import 'package:flutter_3d_controller/src/core/modules/model_viewer/model_viewer.dart';
import 'package:flutter_3d_controller/src/utils/utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_3d_controller/src/core/modules/obj_viewer/object.dart' as obj;
import 'package:vector_math/vector_math_64.dart' hide Colors;

class CustomFlutter3DViewer extends StatefulWidget {
  final String src;
  final Flutter3DController? controller;
  final Color? progressBarColor;
  final bool activeGestureInterceptor;
  final bool enableTouch;
  final bool enableZoom;
  final bool enablePan;
  final bool autoRotate;
  final double rotationSpeed;

  /// Eventos de carga
  final Function(double progressValue)? onProgress;
  final Function(String modelAddress)? onLoad;
  final Function(String error) onError;

  /// Indica si se trata de un modelo OBJ
  final bool isObj;
  final double? scale, cameraX, cameraY, cameraZ;

  const CustomFlutter3DViewer({
    super.key,
    required this.src,
    this.controller,
    this.progressBarColor,
    this.activeGestureInterceptor = true,
    this.enableTouch = true,
    this.autoRotate = true,
    this.rotationSpeed = 20.0,
    this.enableZoom = true,
    this.enablePan = true,
    this.onProgress,
    this.onLoad,
    required this.onError,
  })  : isObj = false,
        scale = null,
        cameraX = null,
        cameraY = null,
        cameraZ = null;

  const CustomFlutter3DViewer.obj({
    super.key,
    required this.src,
    this.scale,
    this.cameraX,
    this.cameraY,
    this.cameraZ,
    this.onProgress,
    this.onLoad,
    required this.onError,
  })  : progressBarColor = null,
        controller = null,
        activeGestureInterceptor = true,
        enableTouch = true,
        isObj = true,
        autoRotate = false,
        rotationSpeed = 0.0,
        enableZoom = true,
        enablePan = true;

  @override
  State<CustomFlutter3DViewer> createState() => _CustomFlutter3DViewerState();
}

class _CustomFlutter3DViewerState extends State<CustomFlutter3DViewer> {
  late Flutter3DController _controller;
  late String _id;
  final Utils _utils = Utils();

  @override
  void initState() {
    super.initState();
    _id = _utils.generateId();
    _controller = widget.controller ?? Flutter3DController();
    
    if (kIsWeb) {
      _controller.init(Flutter3DRepository(IFlutter3DDatasource(_id, null, false)));
    }
  }

  void _handleProgress(double progress) {
    if (widget.onProgress != null) {
      widget.onProgress!(progress);
    }
    debugPrint('🔄 Model Progress: ${progress * 100}%');
  }

  void _handleLoad(String modelAddress) {
    setState(() {
      _controller.onModelLoaded.value = true;
    });
    if (widget.onLoad != null) {
      widget.onLoad!(modelAddress);
    }
    debugPrint('✅ Model Loaded: $modelAddress');
  }

  void _handleError(String error) {
    debugPrint('❌ Model Load Failed: $error');

    setState(() {
      _controller.onModelLoaded.value = false;
    });



        widget.onError!(error);

  }

  @override
  Widget build(BuildContext context) {
    return widget.isObj
        ? ObjViewer(
            src: widget.src,
            interactive: widget.enableTouch,
            onSceneCreated: (scene, modelName, modelUrl) {
              scene.camera.position.z = widget.cameraZ ?? 10;
              scene.camera.target.y = widget.cameraY ?? 0;
              scene.camera.target.x = widget.cameraX ?? 0;
              scene.world.add(
                obj.Object(
                  scale: Vector3(widget.scale ?? 5.0, widget.scale ?? 5.0, widget.scale ?? 5.0),
                  fileName: modelName,
                  url: modelUrl,
                  onProgress: _handleProgress,
                  onLoad: _handleLoad,
                  onError: _handleError,
                ),
              );
            },
          )
        : ModelViewer(
            id: _id,
            src: widget.src,
            progressBarColor: widget.progressBarColor,
            relatedJs: _utils.injectedJS(_id, 'flutter-3d-controller'),
            interactionPrompt: InteractionPrompt.none,
            activeGestureInterceptor: widget.activeGestureInterceptor,
            cameraControls: widget.enableTouch,
            ar: false,
            autoPlay: false,
            debugLogging: true,
            disableTap: true,
            autoRotate: widget.autoRotate,
            rotationPerSecond: '${widget.rotationSpeed}deg',
            disablePan: !widget.enablePan,
            disableZoom: !widget.enableZoom,

            // Eventos de carga
            onProgress: _handleProgress,
            onLoad: _handleLoad,
            onError: _handleError,

            onWebViewCreated: kIsWeb
                ? null
                : (InAppWebViewController value) {
                    _controller.init(
                      Flutter3DRepository(
                        IFlutter3DDatasource(
                          _id,
                          value,
                          widget.activeGestureInterceptor,
                        ),
                      ),
                    );
                  },
          );
  }
}
