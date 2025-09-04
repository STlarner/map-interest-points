import "dart:async";
import "dart:typed_data";

import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:ui/ui.dart";

import "../../dependency_injection/firestore_manager.dart";

class FirebaseAsyncImage extends StatefulWidget {
  const FirebaseAsyncImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<FirebaseAsyncImage> createState() => _FirebaseAsyncImageState();
}

class _FirebaseAsyncImageState extends State<FirebaseAsyncImage> {
  static final Map<String, Uint8List> _imagesCache = {};

  late final Future<Uint8List> _futureImage;

  @override
  void initState() {
    super.initState();
    _futureImage = _loadFirebaseImageBytes();
  }

  Future<Uint8List> _loadFirebaseImageBytes() async {
    if (_imagesCache.containsKey(widget.path)) {
      return _imagesCache[widget.path]!;
    }

    final ref = GetIt.I<FirestoreManager>().getStorageReference(
      filePath: widget.path,
    );

    if (ref == null) {
      GetIt.I<LogProvider>().log(
        "Reference for ${widget.path} is null",
        Severity.error,
      );
      return Uint8List(0);
    }

    final data = await ref.getData(10 * 1024 * 1024);

    if (data == null) {
      GetIt.I<LogProvider>().log(
        "File at ${widget.path} is empty or not accessible.",
        Severity.error,
      );
      throw Exception("File at ${widget.path} is empty or not accessible.");
    }

    _imagesCache[widget.path] = data;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _futureImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1000),
            child: Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey.shade300,
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.red);
        } else {
          return Image.memory(
            snapshot.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
      },
    );
  }
}
