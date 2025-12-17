import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/models/get_jadwal_model.dart';
import 'package:dialisaku/models/perbarui_jadwal_model.dart';
import 'package:dialisaku/providers/get_jadwal_pasien_provider.dart';
import 'package:dialisaku/providers/notification_provider.dart';
import 'package:dialisaku/providers/perbarui_jadwal_provider.dart';
import 'package:dialisaku/screens/home_screen.dart';
import 'package:flutter/material.dart';
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

  bool _fieldsInitialized = false;

  @override
  Widget build(BuildContext context) {
    final perbaruiJadwalState = ref.watch(perbaruiJadwalControllerProvider);
    final jadwalState = ref.watch(getJadwalPasienProvider);

    ref.listen<AsyncValue<PerbaruiJadwalModelResponse?>>(
        perbaruiJadwalControllerProvider, (previous, next) {
      next.when(
        data: (data) async {
          if (data != null && previous is AsyncLoading) {
            final notifService = ref.read(notificationServiceProvider);
            final jadwalDataFromControllers = ModelGetJadwaResponseData(
              id: 0, // Not used for scheduling, safe to use dummy data
              nik: '', // Not used for scheduling, safe to use dummy data
              waktuMakan1: _waktuMakan1Controller.text,
              waktuMakan2: _waktuMakan2Controller.text,
              waktuMakan3: _waktuMakan3Controller.text,
              targetCairanMl:
                  int.tryParse(_targetCairanController.text) ?? 0,
              frekuensiAlarmBbHari:
                  int.tryParse(_frekuensiAlarmController.text) ?? 0,
              waktuAlarmBb: _waktuAlarmController.text,
            );
            await notifService
                .scheduleAllNotificationsForPasien(jadwalDataFromControllers);

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
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          title: const Text('Perbarui Jadwal',
              style: TextStyle(
                  color: AppColors.cardBackground,
                  fontWeight: FontWeight.bold)),
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
        body: jadwalState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Gagal memuat jadwal: $error'),
          ),
          data: (jadwalData) {
            if (jadwalData.data != null && !_fieldsInitialized) {
              final data = jadwalData.data!;
              _waktuMakan1Controller.text = data.waktuMakan1;
              _waktuMakan2Controller.text = data.waktuMakan2;
              _waktuMakan3Controller.text = data.waktuMakan3;
              _targetCairanController.text = data.targetCairanMl.toString();
              _frekuensiAlarmController.text =
                  data.frekuensiAlarmBbHari.toString();
              _waktuAlarmController.text = data.waktuAlarmBb;
              _fieldsInitialized = true;
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20.0.w),
                children: [
                  _buildSectionTitle(context, 'Jadwal Makan'),
                  Divider(
                    color: AppColors.cardBackground,
                  ),
                  _buildInfoCard(context, [
                    _buildTimeField(
                        controller: _waktuMakan1Controller,
                        label: 'Makan Pagi'),
                    SizedBox(height: 8.h),
                    _buildTimeField(
                        controller: _waktuMakan2Controller,
                        label: 'Makan Siang'),
                    SizedBox(height: 8.h),
                    _buildTimeField(
                        controller: _waktuMakan3Controller,
                        label: 'Makan Malam'),
                  ]),
                  SizedBox(height: 24.h),
                  _buildSectionTitle(context, 'Target Asupan Cairan'),
                  Divider(
                    color: AppColors.cardBackground,
                  ),
                  _buildInfoCard(context, [
                    _buildNumericField(
                        controller: _targetCairanController,
                        label: 'Target Cairan (ml)'),
                  ]),
                  SizedBox(height: 24.h),
                  _buildSectionTitle(context, 'Alarm Timbang Berat Badan'),
                  Divider(
                    color: AppColors.cardBackground,
                  ),
                  _buildInfoCard(context, [
                    _buildNumericField(
                        controller: _frekuensiAlarmController,
                        label: 'Frekuensi Alarm (hari)'),
                    SizedBox(height: 8.h),
                    _buildTimeField(
                        controller: _waktuAlarmController,
                        label: 'Waktu Alarm'),
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
                                  .read(
                                      perbaruiJadwalControllerProvider.notifier)
                                  .perbaruiJadwal(request: request);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side:
                              BorderSide(color: AppColors.warning, width: 4.w)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: perbaruiJadwalState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Simpan Perubahan',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
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
          padding: EdgeInsets.all(16.0.w),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildTimeField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
          color: AppColors.cardBackground, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.secondary,
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide(color: AppColors.warning, width: 4),
        ),
        suffixIcon: const Icon(Icons.access_time, color: AppColors.primary),
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: Color.fromARGB(213, 255, 196, 0),
                  onSurface: AppColors.primary,
                ),
                dialogBackgroundColor: AppColors.cardBackground,
              ),
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
    );
  }

  Widget _buildNumericField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
          color: AppColors.cardBackground, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.secondary,
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide(color: AppColors.warning, width: 4),
        ),
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
    );
  }
}
