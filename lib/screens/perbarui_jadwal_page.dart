import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/models/perbarui_jadwal_model.dart';
import 'package:dialisaku/providers/notification_provider.dart';
import 'package:dialisaku/providers/perbarui_jadwal_provider.dart';
import 'package:dialisaku/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerbaruiJadwalPage extends ConsumerStatefulWidget {
  const PerbaruiJadwalPage({super.key});

  @override
  ConsumerState<PerbaruiJadwalPage> createState() => _PerbaruiJadwalPageState();
}

class _PerbaruiJadwalPageState extends ConsumerState<PerbaruiJadwalPage> {
  final _formKey = GlobalKey<FormState>();

  final _waktuMakan1Controller = TextEditingController();
  final _waktuMakan2Controller = TextEditingController();
  final _waktuMakan3Controller = TextEditingController();
  final _targetCairanController = TextEditingController();
  final _frekuensiAlarmController = TextEditingController();
  final _waktuAlarmController = TextEditingController();

  @override
  void dispose() {
    _waktuMakan1Controller.dispose();
    _waktuMakan2Controller.dispose();
    _waktuMakan3Controller.dispose();
    _targetCairanController.dispose();
    _frekuensiAlarmController.dispose();
    _waktuAlarmController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(
          hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
  }

  Future<void> _scheduleNotifications() async {
    final notifService = ref.read(notificationServiceProvider);
    await notifService.cancelAllNotifications();

    // Jadwalkan Makan Pagi (ID: 0)
    final waktuMakan1 = _parseTime(_waktuMakan1Controller.text);
    if (waktuMakan1 != null) {
      await notifService.scheduleDailyNotification(
        id: 0,
        title: 'Waktunya Makan Pagi!',
        body: 'Jangan lupa untuk mencatat menu makan pagi Anda hari ini.',
        time: waktuMakan1,
      );
    }

    // Jadwalkan Makan Siang (ID: 1)
    final waktuMakan2 = _parseTime(_waktuMakan2Controller.text);
    if (waktuMakan2 != null) {
      await notifService.scheduleDailyNotification(
        id: 1,
        title: 'Waktunya Makan Siang!',
        body: 'Jangan lupa untuk mencatat menu makan siang Anda hari ini.',
        time: waktuMakan2,
      );
    }

    // Jadwalkan Makan Malam (ID: 2)
    final waktuMakan3 = _parseTime(_waktuMakan3Controller.text);
    if (waktuMakan3 != null) {
      await notifService.scheduleDailyNotification(
        id: 2,
        title: 'Waktunya Makan Malam!',
        body: 'Jangan lupa untuk mencatat menu makan malam Anda hari ini.',
        time: waktuMakan3,
      );
    }

    // Jadwalkan Timbang Berat Badan (ID: 3)
    final waktuAlarmBb = _parseTime(_waktuAlarmController.text);
    if (waktuAlarmBb != null) {
      await notifService.scheduleDailyNotification(
        id: 3,
        title: 'Waktunya Timbang Berat Badan!',
        body: 'Ayo timbang dan catat berat badan Anda sekarang.',
        time: waktuAlarmBb,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final perbaruiJadwalState = ref.watch(perbaruiJadwalControllerProvider);

    ref.listen<AsyncValue<PerbaruiJadwalModelResponse?>>(
        perbaruiJadwalControllerProvider, (previous, next) {
      next.when(
        data: (data) async {
          if (data != null && previous is AsyncLoading) {
            // Schedule notifications before showing the dialog
            await _scheduleNotifications();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Sukses'),
                content: const Text(
                    'Jadwal berhasil diupdate dan alarm telah diatur.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      ref.read(homeScreenIndexProvider.notifier).state = 0;
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Gagal mengupdate jadwal: ${error.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Perbarui Jadwal'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0.w),
          children: [
            _buildSectionTitle(context, 'Jadwal Makan'),
            _buildInfoCard(context, [
              _buildTimeField(
                  controller: _waktuMakan1Controller, label: 'Makan Pagi'),
              _buildTimeField(
                  controller: _waktuMakan2Controller, label: 'Makan Siang'),
              _buildTimeField(
                  controller: _waktuMakan3Controller, label: 'Makan Malam'),
            ]),
            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'Target Asupan Cairan'),
            _buildInfoCard(context, [
              _buildNumericField(
                  controller: _targetCairanController,
                  label: 'Target Cairan (ml)'),
            ]),
            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'Alarm Timbang Berat Badan'),
            _buildInfoCard(context, [
              _buildNumericField(
                  controller: _frekuensiAlarmController,
                  label: 'Frekuensi Alarm (hari)'),
              _buildTimeField(
                  controller: _waktuAlarmController, label: 'Waktu Alarm'),
            ]),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: perbaruiJadwalState.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        final request = PerbaruiJadwalModelRequest(
                          waktuMakan1: _waktuMakan1Controller.text,
                          waktuMakan2: _waktuMakan2Controller.text,
                          waktuMakan3: _waktuMakan3Controller.text,
                          targetCairanMl:
                              int.parse(_targetCairanController.text),
                          frekuensiAlarmBbHari:
                              int.parse(_frekuensiAlarmController.text),
                          waktuAlarmBb: _waktuAlarmController.text,
                        );
                        ref
                            .read(perbaruiJadwalControllerProvider.notifier)
                            .perbaruiJadwal(request: request);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: perbaruiJadwalState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTimeField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time),
        ),
        readOnly: true,
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            final String formattedTime =
                '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00';
            controller.text = formattedTime;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Waktu tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumericField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field tidak boleh kosong';
          }
          if (int.tryParse(value) == null) {
            return 'Masukkan angka yang valid';
          }
          return null;
        },
      ),
    );
  }
}
