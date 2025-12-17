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
      appBar: AppBar(
        title: const Text(
          'Kontrol Pasien',
          style: TextStyle(
              color: AppColors.cardBackground, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondary,
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
              color: AppColors.warning,
              height: 4.0,
            ),
            preferredSize: const Size.fromHeight(4.0)),
      ),
      backgroundColor: AppColors.secondary,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildControlCard(
            index: 0,
            title: 'Catat Waktu Makan',
            icon: Icons.fastfood_outlined,
            form: _MakanForm(),
          ),
          const SizedBox(height: 16),
          _buildControlCard(
            index: 1,
            title: 'Catat Waktu Minum',
            icon: Icons.local_drink_outlined,
            form: _MinumForm(),
          ),
          const SizedBox(height: 16),
          _buildControlCard(
            index: 2,
            title: 'Catat Berat Badan',
            icon: Icons.monitor_weight_outlined,
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
    required Widget form,
  }) {
    final isExpanded = _expandedIndex == index;
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primary10,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.warning,
            width: 4.w,
          )),
      child: Card(
        color: AppColors.secondary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, size: 40, color: AppColors.cardBackground),
              title: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.cardBackground)),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.primary,
              ),
              onTap: () => _toggleExpand(index),
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: form,
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
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
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: AppColors.cardBackground),
              labelText: 'Keterangan (e.g., Nasi, lauk, sayur)',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.warning,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Simpan',
                    style: TextStyle(color: AppColors.primary),
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
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: AppColors.cardBackground),
              labelText: 'Jumlah (ml)',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
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
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: AppColors.cardBackground),
              labelText: 'Jenis Cairan (e.g., Air putih, teh)',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.warning,
              ),
            ),
            onPressed: isLoading ? null : _submit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan',
                    style: TextStyle(color: AppColors.primary)),
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
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: AppColors.cardBackground),
              labelText: 'Berat Badan (kg)',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.cardBackground,
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
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: AppColors.cardBackground),
                    labelText: 'Sistol (mmHg)',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
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
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: AppColors.cardBackground),
                    labelText: 'Diastol (mmHg)',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.cardBackground,
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.warning,
              ),
            ),
            onPressed: isLoading ? null : _submit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan',
                    style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
