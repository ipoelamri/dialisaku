import 'package:dialisaku/providers/catat_makan_provider.dart';
import 'package:dialisaku/providers/catat_minum_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
//mport 'package:dialisaku/models/catat_minum_model.dart';

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
        title: const Text('Kontrol Pasien'),
        centerTitle: true,
      ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, size: 40),
            title: Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
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
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu makan harus diisi')),
        );
        return;
      }
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day,
          _selectedTime!.hour, _selectedTime!.minute);
      final waktuMakan = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      }
      if (state is AsyncData && state.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data makan berhasil disimpan')),
        );
        _formKey.currentState?.reset();
        _keteranganController.clear();
        setState(() {
          _selectedTime = null;
        });
      }
    });

    final catatMakanState = ref.watch(catatMakanControllerProvider);
    final isLoading = catatMakanState is AsyncLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(_selectedTime == null
                ? 'Pilih Waktu Makan'
                : 'Waktu Makan: ${_selectedTime!.format(context)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context),
          ),
          TextFormField(
            controller: _keteranganController,
            decoration: const InputDecoration(
              labelText: 'Keterangan (e.g., Nasi, lauk, sayur)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan'),
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
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu minum harus diisi')),
        );
        return;
      }
      final now = DateTime.now();

      // final dateTime = DateTime(now.year, now.month, now.day,
      //     _selectedTime!.hour, _selectedTime!.minute);

      ref.read(catatMinumControllerProvider.notifier).catatMinum(
            waktuMinum: DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
            jumlahMl: _jumlahController.text,
            jenisCairan: _jenisCairanController.text,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data minum berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(_selectedTime == null
                ? 'Pilih Waktu Minum'
                : 'Waktu Minum: ${_selectedTime!.format(context)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context),
          ),
          TextFormField(
            controller: _jumlahController,
            decoration: const InputDecoration(
              labelText: 'Jumlah (ml)',
              border: OutlineInputBorder(),
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
              labelText: 'Jenis Cairan (e.g., Air putih, teh)',
              border: OutlineInputBorder(),
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
            onPressed: _submit,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _BeratBadanForm extends StatefulWidget {
  @override
  __BeratBadanFormState createState() => __BeratBadanFormState();
}

class __BeratBadanFormState extends State<_BeratBadanForm> {
  final _formKey = GlobalKey<FormState>();
  final _beratController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal harus diisi')),
        );
        return;
      }
      // TODO: Create a model and service for Berat Badan
      print(
          'Submitting Berat Badan: ${_beratController.text} kg on ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berat badan berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(_selectedDate == null
                ? 'Pilih Tanggal'
                : 'Tanggal: ${DateFormat('dd MMMM yyyy').format(_selectedDate!)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          TextFormField(
            controller: _beratController,
            decoration: const InputDecoration(
              labelText: 'Berat Badan (kg)',
              border: OutlineInputBorder(),
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
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
