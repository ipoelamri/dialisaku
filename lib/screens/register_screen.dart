import 'package:dialisaku/providers/get_jadwal_pasien_provider.dart';
import 'package:dialisaku/providers/notification_provider.dart';
import 'package:dialisaku/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dialisaku/commons/constant.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  String? _selectedEducation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nikController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password tidak sesuai'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
        return;
      }

      final String jenisKelamin = _selectedGender == 'male' ? 'l' : 'p';

      ref.read(registerControllerProvider.notifier).register(
            nik: _nikController.text,
            name: _nameController.text,
            jenisKelamin: jenisKelamin,
            umur: _ageController.text,
            pendidikan: _selectedEducation ?? '',
            alamat: _addressController.text,
            bbAwal: _weightController.text,
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(registerControllerProvider, (previous, next) {
      next.when(
        data: (_) async {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Registrasi berhasil! Menyiapkan jadwal notifikasi...'),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );

            try {
              // Get the new schedule
              final jadwalData =
                  await ref.read(getJadwalPasienProvider.future);
              if (jadwalData.data != null) {
                // Schedule notifications
                final notifService = ref.read(notificationServiceProvider);
                await notifService
                    .scheduleAllNotificationsForPasien(jadwalData.data!);
              }
            } catch (e) {
              // Handle error if fetching schedule or setting notification fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menyiapkan notifikasi: $e'),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            }
            context.go('/home');
          }
        },
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        },
        loading: () {},
      );
    });

    final registerState = ref.watch(registerControllerProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 32.h),
                  // Back Button & Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          'Daftar Akun',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Buat akun baru untuk Dialisaku',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  SizedBox(height: 32.h),
                  // Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // NIK
                          _buildInputField(
                            controller: _nikController,
                            label: 'NIK',
                            hint: 'Masukkan NIK',
                            icon: Icons.badge,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NIK tidak boleh kosong';
                              }
                              if (value.length != 16) {
                                return 'NIK harus 16 digit';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Nama
                          _buildInputField(
                            controller: _nameController,
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Jenis Kelamin
                          _buildDropdownField(
                            label: 'Jenis Kelamin',
                            value: _selectedGender,
                            items: const [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text('Laki-laki'),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text('Perempuan'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            icon: Icons.wc,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih jenis kelamin';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Umur
                          _buildInputField(
                            controller: _ageController,
                            label: 'Umur',
                            hint: 'Masukkan umur',
                            icon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Umur tidak boleh kosong';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Umur harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Pendidikan
                          _buildDropdownField(
                            label: 'Pendidikan',
                            value: _selectedEducation,
                            items: const [
                              DropdownMenuItem(value: 'SD', child: Text('SD')),
                              DropdownMenuItem(
                                value: 'SMP',
                                child: Text('SMP'),
                              ),
                              DropdownMenuItem(
                                value: 'SMA',
                                child: Text('SMA'),
                              ),
                              DropdownMenuItem(value: 'S1', child: Text('S1')),
                              DropdownMenuItem(value: 'S2', child: Text('S2')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedEducation = value;
                              });
                            },
                            icon: Icons.school,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih pendidikan';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Alamat
                          _buildInputField(
                            controller: _addressController,
                            label: 'Alamat',
                            hint: 'Masukkan alamat lengkap',
                            icon: Icons.location_on,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Berat Badan
                          _buildInputField(
                            controller: _weightController,
                            label: 'Berat Badan Awal (kg)',
                            hint: 'Masukkan berat badan',
                            icon: Icons.fitness_center,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Berat badan tidak boleh kosong';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Berat badan harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Password
                          _buildInputField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Masukkan password',
                            icon: Icons.lock,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Confirm Password
                          _buildInputField(
                            controller: _confirmPasswordController,
                            label: 'Konfirmasi Password',
                            hint: 'Ulangi password',
                            icon: Icons.lock,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 28.h),
                          // Register Button
                          SizedBox(
                            height: 56.h,
                            child: ElevatedButton(
                              onPressed:
                                  registerState.isLoading
                                      ? null
                                      : _submitRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: registerState.isLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.w,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Login Link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sudah punya akun? ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Masuk di sini',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixIconColor: AppColors.primary,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixIconColor: AppColors.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
