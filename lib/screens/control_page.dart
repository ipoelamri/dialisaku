import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dialisaku/commons/constant.dart';
import 'package:dialisaku/providers/catat_bb_tensi_provider.dart';
import 'package:dialisaku/providers/catat_makan_provider.dart';
import 'package:dialisaku/providers/catat_minum_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ControlPage extends ConsumerStatefulWidget {
  const ControlPage({super.key});

  @override
  ConsumerState<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends ConsumerState<ControlPage> {
  int? _expandedIndex;

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Kontrol Pasien',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildControlCard(
            index: 0,
            title: 'Catat Waktu Makan',
            icon: Icons.fastfood_outlined,
            color: Colors.orange.shade400,
            form: _MakanForm(),
          ),
          const SizedBox(height: 16),
          _buildControlCard(
            index: 1,
            title: 'Catat Waktu Minum',
            icon: Icons.local_drink_outlined,
            color: Colors.blue.shade400,
            form: _MinumForm(),
          ),
          const SizedBox(height: 16),
          _buildControlCard(
            index: 2,
            title: 'Catat Berat Badan & Tensi',
            icon: Icons.monitor_weight_outlined,
            color: Colors.purple.shade400,
            form: _BeratBadanForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard({
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required Widget form,
  }) {
    final isExpanded = _expandedIndex == index;
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
      child: Column(
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            leading: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(icon, color: color, size: 30.w),
            ),
            title: Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                  color: AppColors.darkText,
                )),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
            ),
            onTap: () => _toggleExpand(index),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: form,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _MakanForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MakanForm> createState() => __MakanFormState();
}

class __MakanFormState extends ConsumerState<_MakanForm> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final waktuMakan = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

      ref.read(catatMakanControllerProvider.notifier).catatMakan(
            waktuMakan: waktuMakan,
            keteranganMakan: _keteranganController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(catatMakanControllerProvider, (_, state) {
      if (state is AsyncError) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'GAGAL',
          desc: state.error.toString(),
          btnOkOnPress: () {},
        ).show();
      }
      if (state is AsyncData && state.value != null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'BERHASIL',
          desc: 'Jam makan berhasil dicatat!',
          btnOkOnPress: () {},
        ).show();
        _formKey.currentState?.reset();
        _keteranganController.clear();
      }
    });

    final catatMakanState = ref.watch(catatMakanControllerProvider);
    final isLoading = catatMakanState is AsyncLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _keteranganController,
            style: const TextStyle(color: AppColors.darkText),
            decoration: InputDecoration(
              labelText: 'Keterangan (e.g., Nasi, lauk, sayur)',
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Keterangan tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    'Simpan',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MinumForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MinumForm> createState() => __MinumFormState();
}

class __MinumFormState extends ConsumerState<_MinumForm> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _jenisCairanController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      ref.read(catatMinumControllerProvider.notifier).catatMinum(
            waktuMinum: DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
            jumlahMl: _jumlahController.text,
            jenisCairan: _jenisCairanController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(catatMinumControllerProvider, (_, state) {
      if (state is AsyncError) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'GAGAL',
          desc: state.error.toString(),
          btnOkOnPress: () {},
        ).show();
      }
      if (state is AsyncData && state.value != null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'BERHASIL',
          desc: 'Cairan berhasil dicatat!',
          btnOkOnPress: () {},
        ).show();
        _formKey.currentState?.reset();
        _jumlahController.clear();
        _jenisCairanController.clear();
      }
    });

    final catatMinumState = ref.watch(catatMinumControllerProvider);
    final isLoading = catatMinumState is AsyncLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _jumlahController,
            style: const TextStyle(color: AppColors.darkText),
            decoration: InputDecoration(
              labelText: 'Jumlah (ml)',
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
                return 'Jumlah tidak boleh kosong';
              }
              if (int.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _jenisCairanController,
            style: const TextStyle(color: AppColors.darkText),
            decoration: InputDecoration(
              labelText: 'Jenis Cairan (e.g., Air putih, teh)',
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jenis cairan tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text('Simpan',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }
}

class _BeratBadanForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BeratBadanForm> createState() => __BeratBadanFormState();
}

class __BeratBadanFormState extends ConsumerState<_BeratBadanForm> {
  final _formKey = GlobalKey<FormState>();
  final _beratController = TextEditingController();
  final _tekananDarahDiastol = TextEditingController();
  final _tekananDarahSistol = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(catatBbTensiControllerProvider.notifier).catatBbTensi(
            tekananDarahDiastol: int.parse(_tekananDarahDiastol.text),
            tekananDarahSistol: int.parse(_tekananDarahSistol.text),
            beratBadanTerukur: int.parse(_beratController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(catatBbTensiControllerProvider, (_, state) {
      if (state is AsyncError) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'GAGAL',
          desc: state.error.toString(),
          btnOkOnPress: () {},
        ).show();
      }
      if (state is AsyncData && state.value != null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'BERHASIL',
          desc: 'Data berat badan berhasil disimpan',
          btnOkOnPress: () {},
        ).show();
        _formKey.currentState?.reset();
        _beratController.clear();
        _tekananDarahDiastol.clear();
        _tekananDarahSistol.clear();
      }
    });

    final catatBbTensiState = ref.watch(catatBbTensiControllerProvider);
    final isLoading = catatBbTensiState is AsyncLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _beratController,
            style: const TextStyle(color: AppColors.darkText),
            decoration: InputDecoration(
              labelText: 'Berat Badan (kg)',
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
                return 'Berat badan tidak boleh kosong';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _tekananDarahSistol,
                  style: const TextStyle(color: AppColors.darkText),
                  decoration: InputDecoration(
                    labelText: 'Sistol (mmHg)',
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
                      return 'Sistol tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    if (int.parse(value) > 200) {
                      return 'Sistol tidak boleh lebih dari 200 mmHg';
                    }
                    if (int.parse(value) < 70) {
                      return 'Sistol diatas 70 mmHg';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _tekananDarahDiastol,
                  style: const TextStyle(color: AppColors.darkText),
                  decoration: InputDecoration(
                    labelText: 'Diastol (mmHg)',
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
                      return 'Diastol tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    if (int.parse(value) > 150) {
                      return 'Diastol tidak boleh lebih dari 150 mmHg';
                    }
                    if (int.parse(value) < 40) {
                      return 'Diastol diatas 60 mmHg';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text('Simpan',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }
}
