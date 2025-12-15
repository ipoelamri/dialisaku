import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/providers/get_jadwal_pasien_provider.dart';
import 'package:dialisaku/widget/ringkasan_pasien_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: authState?.data == null
          ? const Center(child: Text('Tidak ada data pengguna..'))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const HomeHeader(),
                  const DiscountBanner(),
                  const JadwalPasienCard(), // <--- JADWAL CARD DITAMBAHKAN DI SINI
                  const RingkasanPasienCard(),
                  SizedBox(height: 20.h),
                  const Text(
                    'Atur Alarm Kesehatan Anda..',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Categories(),
                  //  const SpecialOffers(),
                  SizedBox(height: 20.h),
                ],
              ),
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
      return time; // Return original string if formatting fails
    }
    return time;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadwalAsync = ref.watch(getJadwalPasienProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: jadwalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Card(
          color: Colors.red[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[700],
                  size: 32.w,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Gagal Memuat Jadwal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pastikan Anda terhubung ke internet. $err',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        data: (jadwalResponse) {
          final jadwal = jadwalResponse.data;
          if (jadwal == null) {
            return Card(
                elevation: 4,
                color: AppColors.primary10,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border:
                          Border.all(color: AppColors.warning, width: 4.w),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(16.0.w),
                        child: const Center(
                            child: Text('Jadwal tidak tersedia.')))));
          }
          return Card(
            elevation: 4,
            color: AppColors.primary10,
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
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Kesehatan Hari Ini',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildJadwalRow(
                      context,
                      icon: Icons.restaurant_menu_outlined,
                      label: 'Jadwal Makan',
                      value:
                          '${_formatTime(jadwal.waktuMakan1)}, ${_formatTime(jadwal.waktuMakan2)}, ${_formatTime(jadwal.waktuMakan3)}',
                    ),
                    const Divider(height: 24),
                    _buildJadwalRow(
                      context,
                      icon: Icons.local_drink_outlined,
                      label: 'Target Cairan',
                      value: '${jadwal.targetCairanMl} ml',
                    ),
                    const Divider(height: 24),
                    _buildJadwalRow(
                      context,
                      icon: Icons.monitor_weight_outlined,
                      label: 'Alarm Berat Badan',
                      value:
                          'Pukul ${_formatTime(jadwal.waktuAlarmBb)} (${jadwal.frekuensiAlarmBbHari} hari sekali)',
                    ),
                  ],
                ),
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 28.w),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          SizedBox(width: 16.w),
          Container(
            // padding: const EdgeInsets.all(2), // ketebalan border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.warning, // warna outline
                width: 4,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                color: AppColors.cardBackground,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}

class SearchField extends ConsumerWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // 1. Dapatkan String yang akan ditampilkan
    final userName = authState?.data?.name ?? 'Pengguna';
    final hintMessage = 'Hallo, $userName!'; // String yang akan ditampilkan

    return Form(
      child: TextFormField(
        onChanged: (value) {},
        decoration: InputDecoration(
          filled: true,

          // 2. Gunakan properti hintText (WAJIB STRING)
          hintText: hintMessage,

          // 3. Gunakan hintStyle untuk mengatur font weight, color, dll.
          hintStyle: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),

          fillColor: AppColors.secondary,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

          // ... Border properties (sudah benar) ...
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: BorderSide(color: AppColors.warning, width: 4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            borderSide: BorderSide(color: AppColors.warning, width: 4),
          ),
        ),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.warning, width: 4.w),
      ),
      child: Lottie.asset(
        'lib/lottie/Medical App.json',
        width: double.infinity,
        height: 250.h,
        fit: BoxFit.fill,
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "icon": Icon(Icons.local_drink_outlined, color: AppColors.primary),
        "text": "Pengingat\nCairan",
      },
      {
        "icon": Icon(Icons.food_bank_outlined, color: AppColors.primary),
        "text": "Pengingat\nMakan",
      },
      {
        "icon": Icon(Icons.monitor_weight_outlined, color: AppColors.primary),
        "text": "Pengingat\nBerat Badan",
      },
      {
        "icon": Icon(Icons.health_and_safety_rounded, color: AppColors.primary),
        "text": "Pengingat\nTensi",
      },
    ];
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  final Widget icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            // height: 56.h,
            // width: 56.w,
            decoration: BoxDecoration(
              color: const Color.fromARGB(103, 90, 155, 212),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.warning, width: 3.w),
            ),
            child: icon,
          ),
          SizedBox(height: 4.h),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242.w,
          height: 100.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                Image.asset(image, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Brands"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: press,
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: const Text("See more"),
        ),
      ],
    );
  }
}

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}
