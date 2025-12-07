import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dialisaku/commons/constant.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userData = authState?.data;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body:
          userData == null
              ? const Center(child: Text('Tidak ada data pengguna.'))
              : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildProfileHeader(context, userData.name),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 16),
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
                    ),
                    _buildInfoRow(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Berat Badan Awal',
                      value: '${userData.bbAwal} kg',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      GoRouter.of(context).go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 50, color: AppColors.secondary),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
