import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraButton extends StatelessWidget {
  final Function(String imagePath) onImageCapture;
  final String buttonText;

  const CameraButton({super.key, required this.onImageCapture, required this.buttonText});

  Future<void> _takePhoto(BuildContext context) async {
    try {
      // request camera permission
      final status = await Permission.camera.request();

      // kondisi pertama = kalo di tolak permissionnya tapi cuma sekali
      if (status.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('camera permission is required to take photos'),
              backgroundColor: Colors.orange,
            )
          );
        }
        return;
      }

      // kondisi kedua = kalo di tolak selamanya, jadi harus di set lewat settings
      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Camera permission denied, please enable in settings'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            )
          );
        }
        return;
      }

      // instruksi ketika permission di allow
      final ImagePicker picker = ImagePicker(); // ini ambil dari library yang ada di pubspec.yaml
      final XFile? photo = await picker.pickImage( // untuk mendefinisikan file2 yang berhubungan dgn aplikasi / 
        source:  ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // ini biar pake kamera depan, naanit trserah bisa di ganti juga
        imageQuality: 70, // compressed image
      );

      // kalo yang absen tanpa photo
      if (photo != null) {
        onImageCapture(photo.path); // ini yang dimasukin path fotonya, bukan png dll
      }
    } catch (e) {
      if (context.mounted) {  // kalo misal kameranya error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _takePhoto(context),
      icon: Icon(Icons.camera_alt),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
      ),
    );
  }
}