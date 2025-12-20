import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/screens/home_page.dart';
import 'package:dialisaku/screens/perbarui_jadwal_page.dart';
import 'package:dialisaku/screens/profile_page.dart';
import 'package:dialisaku/screens/control_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final homeScreenIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ControlPage(),
    PerbaruiJadwalPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeScreenIndexProvider);

    return Scaffold(
      body: _pages.elementAt(currentIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SalomonBottomBar(
          backgroundColor: AppColors.primary,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.warning,
          unselectedItemColor: AppColors.cardBackground,
          onTap: (index) {
            ref.read(homeScreenIndexProvider.notifier).state = index;
          },
          items: _navBarItems,
        ),
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: AppColors.cardBackground,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.note_alt_outlined),
    title: const Text("Catat"),
    selectedColor: AppColors.cardBackground,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.lock_clock),
    title: const Text("Ubah Jadwal"),
    selectedColor: AppColors.cardBackground,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Profile"),
    selectedColor: AppColors.cardBackground,
  ),
];
