import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/models/get_ringkasan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dialisaku/providers/get_ringkasan_pasien_provider.dart';

class RingkasanPasienCard extends ConsumerWidget {
  const RingkasanPasienCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ringkasanAsync = ref.watch(getRingkasanPasienProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ringkasanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildErrorCard(context, err.toString()),
        data: (response) {
          // final tanggal = response.tanggal != null
          //     ? DateFormat('d MMMM yyyy', 'id_ID')
          //         .format(DateTime.parse(response.tanggal!))
          //     : 'Tanggal tidak tersedia';
          final profile = response.profile;
          final realisasi = response.realisasi;

          if (profile == null && realisasi == null) {
            return _buildEmptyCard(context);
          }

          return Card(
            elevation: 6,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.05),
                    AppColors.cardBackground.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Harian',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update: ${response.tanggal ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightText,
                      ),
                    ),
                    const Divider(height: 24, thickness: 1),
                    if (profile != null) _buildProfileSection(context, profile),
                    if (realisasi != null)
                      _buildRealisasiSection(context, realisasi),
                  ],
                ),
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
        _buildSectionTitle(
          context,
          icon: Icons.person_pin_circle_outlined,
          title: 'Profil Pasien',
        ),
        _buildInfoRow(
          context,
          icon: Icons.perm_identity,
          label: 'Nama',
          value: profile.nama ?? '-',
        ),
        _buildInfoRow(
          context,
          icon: Icons.credit_card,
          label: 'NIK',
          value: profile.nik ?? '-',
        ),
        _buildInfoRow(
          context,
          icon: Icons.monitor_weight_outlined,
          label: 'Berat Awal',
          value: '${profile.beratBadanAwal ?? '-'} kg',
        ),
        const Divider(height: 24, thickness: 1),
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
        _buildSectionTitle(
          context,
          icon: Icons.task_alt_outlined,
          title: 'Realisasi Hari Ini',
        ),
        _buildInfoRow(
          context,
          icon: Icons.local_drink_outlined,
          label: 'Total Minum',
          value: '${realisasi.totalMinumMl ?? 0} ml',
        ),
        _buildInfoRow(
          context,
          icon: Icons.opacity,
          label: 'Sisa Cairan',
          value: '${realisasi.sisaCairanMl ?? 0} ml',
        ),
        _buildInfoRow(
          context,
          icon: Icons.scale_outlined,
          label: 'Berat Terukur',
          value: '${realisasi.beratBadanTerukur ?? '-'} kg',
        ),
        _buildInfoRow(
          context,
          icon: Icons.favorite_border_outlined,
          label: 'Tekanan Darah',
          value: '$sistol/$diastol mmHg',
        ),
        _buildInfoRow(
          context,
          icon: Icons.sick_outlined,
          label: 'Keluhan',
          value: realisasi.keluhanHariIni ?? 'Tidak ada keluhan',
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 16),
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.lightText),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      elevation: 4,
      color: AppColors.danger.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(
              'Gagal Memuat Data',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terjadi kesalahan saat mengambil data ringkasan. Silakan coba lagi nanti.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkText.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.lightText,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Data Belum Tersedia',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Saat ini belum ada data ringkasan harian yang dapat ditampilkan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightText),
            ),
          ],
        ),
      ),
    );
  }
}
