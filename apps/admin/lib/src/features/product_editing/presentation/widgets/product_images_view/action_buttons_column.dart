import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/widgets/product_images_view/active_action_button.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/widgets/product_images_view/inactive_action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ActionButtonsColumn extends HookWidget {
  const ActionButtonsColumn({
    super.key,
    required this.onPickImage,
    required this.onCropImage,
    required this.onImageDelete,
  });

  final Future Function(BuildContext, ImageSource) onPickImage;
  final Future Function(BuildContext) onCropImage;
  final Future Function(BuildContext) onImageDelete;

  @override
  Widget build(BuildContext context) {
    final imageFile = useProvider(blopProvider);

    return Column(
      children: [
        !kIsWeb
            ? ActiveActionButton(
                style: AppTheme.buttonTextStyle,
                icon: Icons.camera_alt,
                text: 'Odfotiť obrázok',
                callback: () async {
                  try {
                    final picked =
                        await onPickImage(context, ImageSource.camera);
                    if (picked != null) {
                      await onCropImage(context);
                    }
                  } on PlatformException {
                    debugPrint('camera is not available');
                  }
                },
              )
            : InactiveActionButton(
                text: 'Odfotiť obrázok',
                icon: Icons.camera_alt,
              ),
        ActiveActionButton(
          style: AppTheme.buttonTextStyle,
          icon: Icons.photo,
          text: 'Vybrať obrázok',
          callback: () async {
            try {
              final picked = await onPickImage(context, ImageSource.gallery);
              if (picked != null) {
                await onCropImage(context);
              }
            } on PlatformException {
              debugPrint('gallery not available');
            }
          },
        ),
        imageFile.state == null
            ? InactiveActionButton(
                text: 'Orezať obrázok',
                icon: Icons.crop,
              )
            : ActiveActionButton(
                style: AppTheme.buttonTextStyle,
                icon: Icons.crop,
                text: 'Orezať obrázok',
                callback: () async => onCropImage(context),
              ),
        imageFile.state == null
            ? InactiveActionButton(
                text: 'Odstrániť obrázok',
                icon: Icons.delete,
              )
            : ActiveActionButton(
                style:
                    AppTheme.buttonTextStyle.copyWith(color: Colors.redAccent),
                icon: Icons.delete,
                text: 'Odstrániť obrázok',
                callback: () async => onImageDelete(context),
              ),
      ],
    );
  }
}
