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
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Profil Pasien',
            style: TextStyle(
                color: AppColors.cardBackground, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
              color: AppColors.warning,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
      ),
      body: userData == null
          ? const Center(child: Text('Tidak ada data pengguna.'))
          : ListView(
              padding: EdgeInsets.all(20.0.w),
              children: [
                _buildProfileHeader(context, userData.name, userData.nik),
                SizedBox(height: 24.h),
                _buildSectionTitle(context, 'Data Diri'),
                _buildInfoCard(context, [
                  _buildInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'NIK',
                    value: userData.nik,
                  ),
                  const Divider(color: AppColors.warning),
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: 'Nama Lengkap',
                    value: userData.name,
                  ),
                  const Divider(color: AppColors.warning),
                  _buildInfoRow(
                    icon: Icons.cake_outlined,
                    label: 'Umur',
                    value: '${userData.umur} tahun',
                  ),
                  const Divider(color: AppColors.warning),
                  _buildInfoRow(
                    icon: userData.jenisKelamin.toLowerCase() == 'l'
                        ? Icons.male_outlined
                        : Icons.female_outlined,
                    label: 'Jenis Kelamin',
                    value: userData.jenisKelamin.toLowerCase() == 'l'
                        ? 'Laki-laki'
                        : 'Perempuan',
                  ),
                ]),
                SizedBox(height: 24.h),
                _buildSectionTitle(context, 'Data Kesehatan & Kontak'),
                _buildInfoCard(context, [
                  _buildInfoRow(
                    icon: Icons.school_outlined,
                    label: 'Pendidikan',
                    value: userData.pendidikan,
                  ),
                  const Divider(color: AppColors.warning),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: userData.alamat,
                    isAddress: true,
                  ),
                  const Divider(color: AppColors.warning),
                  _buildInfoRow(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Berat Badan Awal',
                    value: '${userData.bbAwal} kg',
                  ),
                ]),
                SizedBox(height: 32.h),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    GoRouter.of(context).go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout dari Akun'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: AppColors.warning, width: 4.w),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String nik) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.warning,
              width: 4,
            ),
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person_pin, size: 60.w, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          'NIK: $nik',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primary.withOpacity(0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      color: AppColors.cardBackground,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.warning, width: 4.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAddress = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24.w),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(0.8),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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
