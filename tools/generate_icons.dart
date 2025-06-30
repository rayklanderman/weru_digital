import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

void main() async {
  print('Generating app icons...');

  // Icon sizes for Android
  final Map<String, int> iconSizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  print('Icon sizes to generate:');
  iconSizes.forEach((folder, size) {
    print('  $folder: ${size}x$size');
  });

  print('\\nNote: You will need to manually resize the radio_logo.png file');
  print('to the appropriate sizes using an image editor or online tool.');
  print('\\nRecommended tools:');
  print('1. Online: https://www.appicon.co/');
  print(
      '2. Android Asset Studio: https://romannurik.github.io/AndroidAssetStudio/');
  print('3. Any image editor that can batch resize');

  print('\\nCurrent logo location: assets/images/radio_logo.png');
  print('Target folders:');
  iconSizes.forEach((folder, size) {
    print('  android/app/src/main/res/$folder/ic_launcher.png (${size}x$size)');
  });
}
