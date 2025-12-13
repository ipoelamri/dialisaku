import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dialisaku/commons/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Asumsi model LoginResponseModel tersedia untuk userData
// class LoginResponseModel { final String name, nik, jenisKelamin, pendidikan, alamat; final int umur; final double bbAwal; }

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userData = authState?.data;

    return Scaffold(
      // Menggunakan background utama yang terang, bukan primary
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Pasien'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardBackground, // Teks putih
        elevation: 0,
      ),
      body:
          userData == null
              ? const Center(child: Text('Tidak ada data pengguna.'))
              : ListView(
                padding: EdgeInsets.all(20.0.w),
                children: [
                  // Header (Icon & Nama)
                  _buildProfileHeader(context, userData.name, userData.nik),
                  SizedBox(height: 24.h),

                  // Info Grup 1: Data Identitas
                  _buildSectionTitle(context, 'Data Diri'),
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'NIK',
                      value: userData.nik,
                    ),
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Nama Lengkap',
                      value: userData.name,
                    ),
                    _buildInfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Umur',
                      value: '${userData.umur} tahun',
                    ),
                    _buildInfoRow(
                      icon:
                          userData.jenisKelamin.toLowerCase() == 'l'
                              ? Icons.male_outlined
                              : Icons.female_outlined,
                      label: 'Jenis Kelamin',
                      value:
                          userData.jenisKelamin.toLowerCase() == 'l'
                              ? 'Laki-laki'
                              : 'Perempuan',
                    ),
                  ]),
                  SizedBox(height: 16.h),

                  // Info Grup 2: Data Kesehatan & Kontak
                  _buildSectionTitle(context, 'Data Kesehatan & Kontak'),
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      icon: Icons.school_outlined,
                      label: 'Pendidikan',
                      value: userData.pendidikan,
                    ),
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Alamat',
                      value: userData.alamat,
                      isAddress: true, // Untuk layout vertikal
                    ),
                    _buildInfoRow(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Berat Badan Awal',
                      value: '${userData.bbAwal} kg',
                    ),
                  ]),

                  SizedBox(height: 32.h),

                  // Tombol Logout (Menggunakan warna Danger)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lakukan logout dan arahkan ke halaman login
                      ref.read(authProvider.notifier).logout();
                      GoRouter.of(context).go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout dari Akun'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.danger, // Warna Merah untuk Logout
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 6,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String nik) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: AppColors.primary10, // Opacity warna Primary
          child: Icon(Icons.person_pin, size: 60.w, color: AppColors.primary),
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'NIK: $nik',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.lightText,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary, // Latar belakang putih
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black10,
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAddress = false, // Flag untuk menangani Alamat (multiline)
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 24.w),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.accent, // Warna teks sekunder
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                // Nilai Informasi
                Text(
                  value,
                  // Teks alamat bisa multiline
                  maxLines: isAddress ? 3 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cardBackground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
