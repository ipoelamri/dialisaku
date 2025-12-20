import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/models/get_ringkasan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dialisaku/providers/get_ringkasan_pasien_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RingkasanPasienCard extends ConsumerWidget {
  const RingkasanPasienCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ringkasanAsync = ref.watch(getRingkasanPasienProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: ringkasanAsync.when(
        loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.primary, size: 50)),
        error: (err, stack) => _buildErrorCard(context, err.toString()),
        data: (response) {
          final profile = response.profile;
          final realisasi = response.realisasi;

          if (profile == null && realisasi == null) {
            return _buildEmptyCard(context);
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Harian',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Update: ${response.tanggal ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const Divider(height: 25),
                  if (profile != null) _buildProfileSection(context, profile),
                  if (realisasi != null)
                    _buildRealisasiSection(context, realisasi),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    ModelGetRingkasanResponseprofile profile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title: 'Profil Pasien'),
        SizedBox(height: 15.h),
        _buildInfoRow(
          context,
          icon: Icons.perm_identity,
          label: 'Nama',
          value: profile.nama ?? '-',
          color: Colors.blue.shade400,
        ),
        _buildInfoRow(
          context,
          icon: Icons.credit_card,
          label: 'NIK',
          value: profile.nik ?? '-',
          color: Colors.green.shade400,
        ),
        _buildInfoRow(
          context,
          icon: Icons.monitor_weight_outlined,
          label: 'Berat Awal',
          value: '${profile.beratBadanAwal ?? '-'} kg',
          color: Colors.purple.shade400,
        ),
        const Divider(height: 25),
      ],
    );
  }

  Widget _buildRealisasiSection(
    BuildContext context,
    ModelGetRingkasanResponseRealisasi realisasi,
  ) {
    final sistol = realisasi.tekananDarahSistol ?? '-';
    final diastol = realisasi.tekananDarahDiastol ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title: 'Realisasi Hari Ini'),
        SizedBox(height: 15.h),
        _buildInfoRow(
          context,
          icon: Icons.local_drink_outlined,
          label: 'Total Minum',
          value: '${realisasi.totalMinumMl ?? 0} ml',
          color: Colors.lightBlue.shade300,
        ),
        _buildInfoRow(
          context,
          icon: Icons.restaurant_menu_outlined,
          label: 'Jumlah Makan Dicatat',
          value: '${realisasi.jmlhMakanDicatat ?? 0} kali',
          color: Colors.orange.shade400,
        ),
        _buildInfoRow(
          context,
          icon: Icons.opacity,
          label: 'Sisa Cairan',
          value: '${realisasi.sisaCairanMl ?? 0} ml',
          color: Colors.cyan.shade400,
        ),
        _buildInfoRow(
          context,
          icon: Icons.scale_outlined,
          label: 'Berat Terukur',
          value: '${realisasi.beratBadanTerukur ?? '-'} kg',
          color: Colors.pink.shade300,
        ),
        _buildInfoRow(
          context,
          icon: Icons.favorite_border_outlined,
          label: 'Tekanan Darah',
          value: '$sistol/$diastol mmHg',
          color: Colors.red.shade400,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
  }) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 40.w),
          SizedBox(height: 12.h),
          Text(
            'Gagal Memuat Data',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Terjadi kesalahan saat mengambil data ringkasan. Silakan coba lagi nanti.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[400],
            size: 40.w,
          ),
          SizedBox(height: 12.h),
          Text(
            'Data Belum Tersedia',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Saat ini belum ada data ringkasan harian yang dapat ditampilkan.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
