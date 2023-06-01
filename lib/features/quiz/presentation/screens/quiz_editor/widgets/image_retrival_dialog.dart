import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testador/core/components/custom_dialog.dart';
import 'package:testador/core/components/theme/app_theme.dart';
import 'package:testador/core/utils/translator.dart';

class ImageRetrivalDialog extends StatefulWidget {
  final Function(XFile imageFile) onImageRetrived;
  const ImageRetrivalDialog({super.key, required this.onImageRetrived});

  @override
  State<ImageRetrivalDialog> createState() => _ImageRetrivalDialogState();
}

class _ImageRetrivalDialogState extends State<ImageRetrivalDialog> {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return CustomDialog(
      fitContent: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: kIsWeb
                ? null
                : () async {
                    Navigator.pop(context);
                    final file =
                        await picker.pickImage(source: ImageSource.camera);
                    if (file == null) return;
                    widget.onImageRetrived(file);
                  },
            child: Ink(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.camera_alt, color: kIsWeb ? Colors.grey : null),
                  Text(
                    context.translator.camera,
                    style: const TextStyle(color: kIsWeb ? Colors.grey : null),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file == null) return;
              widget.onImageRetrived(file);
            },
            child: Ink(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.photo),
                Text(context.translator.gallery),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
