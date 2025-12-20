import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
              id: 0,
              nik: '',
              waktuMakan1: _waktuMakan1Controller.text,
              waktuMakan2: _waktuMakan2Controller.text,
              waktuMakan3: _waktuMakan3Controller.text,
              targetCairanMl: int.tryParse(_targetCairanController.text) ?? 0,
              frekuensiAlarmBbHari:
                  int.tryParse(_frekuensiAlarmController.text) ?? 0,
              waktuAlarmBb: _waktuAlarmController.text,
            );
            await notifService
                .scheduleAllNotificationsForPasien(jadwalDataFromControllers);

            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.success,
              title: 'Sukses',
              desc: 'Jadwal berhasil diupdate dan alarm telah diatur.',
              btnOkOnPress: () {
                ref.read(homeScreenIndexProvider.notifier).state = 0;
              },
            ).show();
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            title: 'Error',
            desc: 'Gagal mengupdate jadwal: ${error.toString()}',
            btnOkOnPress: () {},
          ).show();
        },
      );
    });

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Perbarui Jadwal',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: jadwalState.when(
          loading: () => Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.primary, size: 50)),
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
                  SizedBox(height: 10.h),
                  _buildInfoCard(context, [
                    _buildTimeField(
                        controller: _waktuMakan1Controller,
                        label: 'Makan Pagi'),
                    SizedBox(height: 12.h),
                    _buildTimeField(
                        controller: _waktuMakan2Controller,
                        label: 'Makan Siang'),
                    SizedBox(height: 12.h),
                    _buildTimeField(
                        controller: _waktuMakan3Controller,
                        label: 'Makan Malam'),
                  ]),
                  SizedBox(height: 24.h),
                  _buildSectionTitle(context, 'Target Asupan Cairan'),
                  SizedBox(height: 10.h),
                  _buildInfoCard(context, [
                    _buildNumericField(
                        controller: _targetCairanController,
                        label: 'Target Cairan (ml)'),
                  ]),
                  SizedBox(height: 24.h),
                  _buildSectionTitle(context, 'Alarm Timbang Berat Badan'),
                  SizedBox(height: 10.h),
                  _buildInfoCard(context, [
                    _buildNumericField(
                        controller: _frekuensiAlarmController,
                        label: 'Frekuensi Alarm (hari)'),
                    SizedBox(height: 12.h),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: perbaruiJadwalState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text('Simpan Perubahan',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp)),
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(children: children),
    );
  }

  Widget _buildTimeField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppColors.darkText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
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
                  surface: Colors.white,
                  onSurface: AppColors.darkText,
                ),
                dialogBackgroundColor: Colors.white,
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
      style: const TextStyle(color: AppColors.darkText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
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
