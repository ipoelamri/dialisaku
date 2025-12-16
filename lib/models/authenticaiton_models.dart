class RegisterRequest {
  final String nik;
  final String name;
  final String jenisKelamin;
  final String umur;
  final String pendidikan;
  final String alamat;
  final String bbAwal;
  final String password;
  final String passwordConfirmation;

  RegisterRequest({
    required this.nik,
    required this.name,
    required this.jenisKelamin,
    required this.umur,
    required this.pendidikan,
    required this.alamat,
    required this.bbAwal,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'name': name,
      'jenis_kelamin': jenisKelamin,
      'umur': umur,
      'pendidikan': pendidikan,
      'alamat': alamat,
      'bb_awal': bbAwal,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class LoginRequest {
  final String nik;
  final String password;

  LoginRequest({required this.nik, required this.password});

  Map<String, dynamic> toJson() {
    return {'nik': nik, 'password': password};
  }
}

class RegisterResponse {
  final String status;
  final String message;
  final UserData? data;
  final String? accessToken;
  final String? tokenType;

  RegisterResponse({
    required this.status,
    required this.message,
    this.data,
    this.accessToken,
    this.tokenType,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'],
      message: json['message'],
      data:
          json['data'] != null
              ? UserData.fromJson(json['data'])
              : null,
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

class LoginResponse {
  final String status;
  final String message;
  final UserData? data;
  final String? accessToken;
  final String? tokenType;

  const LoginResponse({
    required this.status,
    required this.message,
    this.data,
    this.accessToken,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data:
          json['data'] != null
              ? UserData.fromJson(json['data'])
              : null,
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}

class UserData {
  final String nik;
  final String name;
  final String jenisKelamin;
  final String umur;
  final String pendidikan;
  final String alamat;
  final String bbAwal;

  UserData({
    required this.nik,
    required this.name,
    required this.jenisKelamin,
    required this.umur,
    required this.pendidikan,
    required this.alamat,
    required this.bbAwal,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      nik: json['nik'],
      name: json['name'],
      jenisKelamin: json['jenis_kelamin'],
      umur: json['umur'].toString(),
      pendidikan: json['pendidikan'],
      alamat: json['alamat'],
      bbAwal: json['bb_awal'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'name': name,
      'jenis_kelamin': jenisKelamin,
      'umur': umur,
      'pendidikan': pendidikan,
      'alamat': alamat,
      'bb_awal': bbAwal,
    };
  }
}
