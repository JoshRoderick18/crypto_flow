import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CryptoImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CryptoImage({super.key, required this.imageUrl, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,

        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.grey[200],
          child: const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(strokeWidth: 2)),
        ),

        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: Icon(Icons.currency_bitcoin, color: Colors.grey[600], size: size * 0.6),
        ),
      ),
    );
  }
}
