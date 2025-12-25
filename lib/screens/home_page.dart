import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/providers/get_jadwal_pasien_provider.dart';
import 'package:dialisaku/widget/ringkasan_pasien_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: authState?.data == null
          ? const Center(
              child: Text(
              'Tidak ada data pengguna..',
              style: TextStyle(color: Colors.black),
            ))
          : Stack(
              children: [
                // Decorative background
                Container(
                  height: 220.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        const HomeHeader(),
                        SizedBox(height: 30.h),
                        const AnimationBanner(),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: SectionTitle(
                            title: 'Kategori Pengingat',
                            press: () {},
                          ),
                        ),
                        SizedBox(height: 15.h),
                        const Categories(),
                        SizedBox(height: 20.h),
                        const JadwalPasienCard(),
                        const RingkasanPasienCard(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class JadwalPasienCard extends ConsumerWidget {
  const JadwalPasienCard({Key? key}) : super(key: key);

  String _formatTime(String? time) {
    if (time == null) return '--:--';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    } catch (e) {
      // Return original string if formatting fails
    }
    return time;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadwalAsync = ref.watch(getJadwalPasienProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: jadwalAsync.when(
        loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.primary, size: 50)),
        error: (err, stack) => Card(
          elevation: 2,
          color: AppColors.warning,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40.w),
                SizedBox(height: 12.h),
                Text('Gagal Memuat Jadwal',
                    style: TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp)),
                SizedBox(height: 8.h),
                Text(
                  'Tidak dapat mengambil data jadwal. Pastikan Anda terhubung ke internet dan coba lagi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.background),
                ),
              ],
            ),
          ),
        ),
        data: (jadwalResponse) {
          final jadwal = jadwalResponse.data;
          if (jadwal == null) {
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
              child:
                  const Center(child: Text('Jadwal pengingat belum diatur.')),
            );
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
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Kesehatan Anda',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'untuk aktifkan alarm, pergi ke menu ubah jadwal untuk tetapkan jadwal anda',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  _buildJadwalRow(
                    context,
                    icon: Icons.restaurant_menu_outlined,
                    label: 'Jadwal Makan',
                    value:
                        '${_formatTime(jadwal.waktuMakan1)}, ${_formatTime(jadwal.waktuMakan2)}, ${_formatTime(jadwal.waktuMakan3)}',
                    color: Colors.orange.shade400,
                  ),
                  const Divider(height: 25),
                  _buildJadwalRow(
                    context,
                    icon: Icons.local_drink_outlined,
                    label: 'Target Cairan Harian',
                    value: '${jadwal.targetCairanMl} ml',
                    color: Colors.blue.shade400,
                  ),
                  const Divider(height: 25),
                  _buildJadwalRow(
                    context,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Alarm Berat Badan',
                    value:
                        'Pukul ${_formatTime(jadwal.waktuAlarmBb)} (${jadwal.frekuensiAlarmBbHari} hari sekali)',
                    color: Colors.purple.shade400,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJadwalRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 24.w),
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
    );
  }
}

class HomeHeader extends ConsumerWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    final userName = authState?.data?.name ?? 'Pengguna';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hallo, selamat datang',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // CircleAvatar(
          //   radius: 26.r,
          //   backgroundColor: Colors.white.withOpacity(0.9),
          //   child: CircleAvatar(
          //     radius: 24.r,
          //     backgroundColor: AppColors.primary,
          //     child: Icon(Icons.person_outline,
          //         color: Colors.white, size: 30.r),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AnimationBanner extends StatelessWidget {
  const AnimationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF83A4D4).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //flex: 2,
          Lottie.asset(
            'lib/lottie/Medical App.json',
            height: 180.h,
            width: 220.w,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 2.h),

          Text(
            "Pantau Kesehatan Anda",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Catat asupan cairan, makanan, dan berat badan setiap hari.",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.local_drink_outlined, "text": "Cairan"},
      {"icon": Icons.food_bank_outlined, "text": "Makan"},
      {"icon": Icons.monitor_weight_outlined, "text": "Berat Badan"},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {},
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primary, size: 32.w),
            ),
            SizedBox(height: 10.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({Key? key, required this.title, required this.press})
      : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        // TextButton(
        //   onPressed: press,
        //   style: TextButton.styleFrom(
        //     foregroundColor: AppColors.primary,
        //     textStyle: TextStyle(
        //       fontSize: 13.sp,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   child: const Text("View All"),
        // ),
      ],
    );
  }
}
