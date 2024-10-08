// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:octo_image/octo_image.dart';

final _widthScopedProvider =
    Provider<double?>((_) => throw UnimplementedError());

class ProductImage extends HookConsumerWidget {
  static final borderRadius = BorderRadius.circular(6);

  final String? imagePath;
  final BoxFit fit;

  /// This widget gets painted on top of successfully displayed image.
  final Widget Function(String imgUrl)? overlayWidget;

  final double? width;

  const ProductImage({
    Key? key,
    this.imagePath,
    this.fit = BoxFit.cover,
    this.overlayWidget,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imagePath == null || imagePath == ref.watch(defaultProductImage)) {
      return ProviderScope(
        overrides: [
          _widthScopedProvider.overrideWithValue(width),
        ],
        child: const _PlaceHolderProductImage(),
      );
    } else {
      final downloadUrl = ref.watch(downloadUrlProvider(imagePath!));

      return ProviderScope(
        overrides: [
          _widthScopedProvider.overrideWithValue(width),
        ],
        child: downloadUrl.maybeWhen(
          data: (imageUrl) => imageUrl == null
              ? const _PlaceHolderProductImage()
              : ClipRRect(
                  borderRadius: borderRadius,
                  child: Stack(
                    children: [
                      OctoImage(
                        filterQuality: FilterQuality.none,
                        image: NetworkImage(imageUrl),
                        fit: fit,
                        width: width,
                        errorBuilder: (_, __, ___) =>
                            const _PlaceHolderProductImage(),
                        placeholderBuilder: (_) =>
                            const _PlaceHolderProductImage(),
                      ),
                      if (overlayWidget != null)
                        Positioned.fill(child: overlayWidget!.call(imageUrl)),
                    ],
                  ),
                ),
          orElse: () => const _PlaceHolderProductImage(),
        ),
      );
    }
  }
}

class _PlaceHolderProductImage extends HookConsumerWidget {
  @literal
  const _PlaceHolderProductImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(defaultProductImage);

    return ClipRRect(
      borderRadius: ProductImage.borderRadius,
      child: Image.asset(
        imagePath,
        width: ref.watch(_widthScopedProvider),
        fit: BoxFit.cover,
      ),
    );
  }
}
