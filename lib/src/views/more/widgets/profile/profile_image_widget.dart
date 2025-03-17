import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodels/image_controller.dart';
import '../../../../viewmodels/user_setting/user_setting_view_model.dart';

class ProfileImageWidget extends ConsumerStatefulWidget {
  const ProfileImageWidget({
    super.key,
    required this.radius,
  });

  final double radius;

  @override
  ConsumerState<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends ConsumerState<ProfileImageWidget> {
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    final userSettingState = ref.watch(userSettingViewModelProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final image = await ImageController().pickImageFromGallery();
            if (image != null) {
              setState(() {
                selectedImage = image;
              });
              // 선택된 이미지를 직접 전달
              await ref
                  .read(userSettingViewModelProvider.notifier)
                  .updateProfileImg(image);
            }
          },
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: userSettingState.when(
              data: (userSetting) {
                if (selectedImage != null) {
                  return FileImage(File(selectedImage!.path));
                }
                if (userSetting.profileImgUrl != null &&
                    userSetting.profileImgUrl!.isNotEmpty) {
                  return NetworkImage(userSetting.profileImgUrl!);
                }
                return const AssetImage('lib/core/imgs/images/StudyDuck.png');
              },
              loading: () =>
                  const AssetImage('lib/core/imgs/images/StudyDuck.png'),
              error: (_, __) =>
                  const AssetImage('lib/core/imgs/images/StudyDuck.png'),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              final image = await ImageController().pickImageFromGallery();
              if (image != null) {
                setState(() {
                  selectedImage = image;
                });
                // 촬영된 이미지를 직접 전달
                await ref
                    .read(userSettingViewModelProvider.notifier)
                    .updateProfileImg(image);
              }
            },
            child: CircleAvatar(
              radius: widget.radius * 0.25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                size: widget.radius * 0.4,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
