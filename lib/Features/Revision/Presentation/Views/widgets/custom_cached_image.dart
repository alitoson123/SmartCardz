import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}
