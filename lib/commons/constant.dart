import 'package:flutter/material.dart';

class AppColors {
  // Primary: Teal kebiruan yang kokoh, melambangkan air/kesehatan/otoritas
  static const Color primary = Color(0xFF007B9E); // Strong Teal Blue
  // Secondary: Warna mint/hijau cerah untuk status 'OK' atau 'Go'
  static const Color secondary = Color.fromARGB(
    103,
    90,
    155,
    212,
  ); // Vibrant Mint

  // 2. BACKGROUND & SURFACE
  // Background: Sangat terang, menghindari putih murni untuk mengurangi ketegangan mata
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Light Blue-Grey Background
  static const Color cardBackground = Color(
    0xFFFFFFFF,
  ); // White for card surfaces

  // 3. TEXT & UI ELEMENTS
  // Dark Text: Kontras tinggi untuk teks utama
  static const Color darkText = Color(0xFF2D3748);
  // Light Text: Abu-abu sedang untuk teks sekunder/informasi tambahan
  static const Color lightText = Color(0xFF718096);

  // 4. ACCENTS & STATUS
  // Accent: Kuning-kehijauan cerah untuk menyorot alarm, target, atau tombol Aksi.
  // Ini juga memberi energi dan membedakan dari Primary Blue.
  static const Color accent = Color(0xFFFFC300); // Bright Gold/Yellow Accent

  // Danger: Merah yang jelas untuk status kritis (misalnya, cairan berlebih, TD tinggi)
  static const Color danger = Color(0xFFE53E3E);

  // Warning: Kuning untuk status peringatan (misalnya, BB mendekati batas aman)
  static const Color warning = Color(0xFFF6AD55);

  // 5. OPACITY HELPERS
  static const Color primary80 = Color(0xCC007B9E); // 80% opacity
  static const Color primary10 = Color(0x1A007B9E); // 10% opacity
  static const Color black10 = Color(0x1A000000); // 10% black opacity
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
