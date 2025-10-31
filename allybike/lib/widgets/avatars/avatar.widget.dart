import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarUserImage extends StatelessWidget {
  final String url;
  final double size;

  const AvatarUserImage({super.key, required this.url, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => Image.asset(
          "assets/images/placeholder_avatar.png",
          width: size,
          height: size,
        ),
      ),
    );
  }
}
