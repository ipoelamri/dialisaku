import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007A7C); // A calming, strong teal/blue
  static const Color secondary = Color(0xFF50E3C2); // A vibrant, modern mint for accents
  
  static const Color background = Color(0xFFF5F7FA); // A very light, clean grey
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards

  static const Color darkText = Color(0xFF2D3748); // Dark grey for primary text
  static const Color lightText = Color(0xFF718096); // Lighter grey for secondary text
  
  static const Color accent = Color(0xFFF6AD55); // An orange accent for special items
  static const Color danger = Color(0xFFE53E3E); // A clear red for errors
  
  // Opacity helpers based on new primary
  static const Color primary80 = Color(0xCC007A7C);
  static const Color primary10 = Color(0x1A007A7C);
  static const Color black10 = Color(0x1A000000);
}

Widget drawerItem({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(title, style: const TextStyle(color: AppColors.darkText)),
    onTap: onTap,
  );
}

