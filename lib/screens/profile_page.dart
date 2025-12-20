import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dialisaku/commons/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    final userData = authState?.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
        title: const Text(
          'Profil Pasien',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: userData == null
          ? const Center(
              child: Text('Tidak ada data pengguna.',
                  style: TextStyle(color: AppColors.darkText)))
          : ListView(
              padding: EdgeInsets.all(20.0.w),
              children: [
                _buildProfileHeader(context, userData.name, userData.nik),
                SizedBox(height: 30.h),
                _buildSectionTitle(context, 'Data Diri'),
                SizedBox(height: 15.h),
                _buildInfoCard(context, [
                  _buildInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'NIK',
                    value: userData.nik,
                    color: Colors.blue.shade400,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: 'Nama Lengkap',
                    value: userData.name,
                    color: Colors.green.shade400,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.cake_outlined,
                    label: 'Umur',
                    value: '${userData.umur} tahun',
                    color: Colors.orange.shade400,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: userData.jenisKelamin.toLowerCase() == 'l'
                        ? Icons.male_outlined
                        : Icons.female_outlined,
                    label: 'Jenis Kelamin',
                    value: userData.jenisKelamin.toLowerCase() == 'l'
                        ? 'Laki-laki'
                        : 'Perempuan',
                    color: Colors.purple.shade400,
                  ),
                ]),
                SizedBox(height: 30.h),
                _buildSectionTitle(context, 'Data Kesehatan & Kontak'),
                SizedBox(height: 15.h),
                _buildInfoCard(context, [
                  _buildInfoRow(
                    icon: Icons.school_outlined,
                    label: 'Pendidikan',
                    value: userData.pendidikan,
                    color: Colors.teal.shade400,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: userData.alamat,
                    isAddress: true,
                    color: Colors.red.shade400,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Berat Badan Awal',
                    value: '${userData.bbAwal} kg',
                    color: Colors.indigo.shade400,
                  ),
                ]),
                SizedBox(height: 32.h),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    GoRouter.of(context).go('/login');
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout dari Akun',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    textStyle:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
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
        SizedBox(height: 10.h),
        CircleAvatar(
          radius: 55.r,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person_outline, size: 60.w, color: Colors.white),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          'NIK: $nik',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isAddress = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  maxLines: isAddress ? 3 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
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
