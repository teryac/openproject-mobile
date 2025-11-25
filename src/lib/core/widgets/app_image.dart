import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool _shimmer;
  final Alignment alignment;
  final bool disableCaching;
  final bool ignoreHttpCachingRules;
  final Widget Function(BuildContext context)? errorBuilder;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.disableCaching = false,
    this.ignoreHttpCachingRules = false,
  }) : _shimmer = true;

  const AppNetworkImage.noShimmer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.disableCaching = false,
    this.ignoreHttpCachingRules = false,
  }) : _shimmer = false;

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  Key imageKey = UniqueKey();

  void reloadImage() {
    setState(() {
      imageKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        key: imageKey,
        imageUrl: widget.imageUrl,
        cacheManager: widget.ignoreHttpCachingRules
            ? CacheManager(
                Config(
                  'avatarCache',
                  stalePeriod: Duration(days: 30),
                  maxNrOfCacheObjects: 200,
                  repo: JsonCacheInfoRepository(databaseName: 'avatarCache'),
                  fileService: HttpFileService(),
                ),
              )
            : null,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        fit: widget.fit,
        cacheKey: widget.disableCaching
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : null,
        placeholder: widget._shimmer ? ((context, url) => placeholder) : null,
        errorWidget: (context, url, error) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context);
          }

          return InkWell(
            borderRadius: widget.borderRadius,
            onTap: () {
              // Force reload (rebuilding CachedNetworkImage reloads it)
              reloadImage();
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.refresh, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.clipBehavior = Clip.hardEdge,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
        child: image,
      );
    }

    return image;
  }
}
