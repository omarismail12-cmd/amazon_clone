import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';

/// Renders a product image from a network URL. `DecorationImage` (used
/// throughout this app for product thumbnails) has no way to react to a
/// failed load — a broken or expired URL just paints nothing, leaving a
/// blank box. `Image.network`'s `errorBuilder` does react, so this renders
/// a visible placeholder instead of silently going blank.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });

  final String? imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final String? url = imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder();
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: greyShade1,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: grey,
      ),
    );
  }
}
