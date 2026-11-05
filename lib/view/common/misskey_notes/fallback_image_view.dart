import "dart:typed_data";

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/util/fallback_image_decoder.dart";

/// 一度結果が出たURLは覚えておく
///
/// 同じ絵文字は一つのノートの中でも何度も出るので、そのたびに
/// フェッチとデコードをやり直すと素直に重い。読めなかったことも
/// 覚えておいて、二度目以降は即座にエラーへ落とす。
const _cacheLimit = 128;
final _decodedCache = <String, Uint8List?>{};

/// Skiaが読めなかった画像を package:image で読み直して表示する
///
/// PGM / PPM / TGA / TIFF / PBM あたりが対象。
/// それでも読めなければ [errorBuilder] に落とす。
class FallbackImageView extends ConsumerStatefulWidget {
  final String url;
  final WidgetBuilder errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const FallbackImageView({
    required this.url,
    required this.errorBuilder,
    super.key,
    this.loadingBuilder,
    this.width,
    this.height,
    this.fit,
  });

  @override
  ConsumerState<FallbackImageView> createState() => FallbackImageViewState();
}

class FallbackImageViewState extends ConsumerState<FallbackImageView> {
  late Future<Uint8List?> _png;

  @override
  void initState() {
    super.initState();
    _png = _resolve();
  }

  @override
  void didUpdateWidget(covariant FallbackImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _png = _resolve();
    }
  }

  Future<Uint8List?> _resolve() async {
    final url = widget.url;
    if (_decodedCache.containsKey(url)) return _decodedCache[url];

    Uint8List? png;
    try {
      final file = await ref.read(cacheManagerProvider).getSingleFile(url);
      png = await decodeFallbackImage(await file.readAsBytes());
    } catch (_) {
      png = null;
    }

    if (_decodedCache.length >= _cacheLimit) {
      _decodedCache.remove(_decodedCache.keys.first);
    }
    _decodedCache[url] = png;
    return png;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _png,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.loadingBuilder?.call(context) ??
              SizedBox(width: widget.width, height: widget.height);
        }
        final png = snapshot.data;
        if (png == null) return widget.errorBuilder(context);
        return Image.memory(
          png,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, _, _) => widget.errorBuilder(context),
        );
      },
    );
  }
}
