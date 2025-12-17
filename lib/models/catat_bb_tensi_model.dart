class CatatBbTensiModelRequest {
  final int tekananDarahSistol;
  final int tekananDarahDiastol;
  final int beratBadanTerukur;

  const CatatBbTensiModelRequest({
    required this.tekananDarahSistol,
    required this.tekananDarahDiastol,
    required this.beratBadanTerukur,
  });

  Map<String, dynamic> toJson() {
    return {
      'tekanan_darah_sistol': tekananDarahSistol,
      'tekanan_darah_diastol': tekananDarahDiastol,
      'berat_badan_terukur': beratBadanTerukur,
    };
  }
}

class CatatBbTensiModelResponse {
  final String message;
  final CatatBbTensiModelResponseData data;

  const CatatBbTensiModelResponse({
    required this.message,
    required this.data,
  });

  factory CatatBbTensiModelResponse.fromJson(Map<String, dynamic> json) {
    return CatatBbTensiModelResponse(
      message: json['message'],
      data: CatatBbTensiModelResponseData.fromJson(json['data']),
    );
  }
}

class CatatBbTensiModelResponseData {
  final int id;
  final String nik;
  final String tanggal;
  final int beratBadanTerukur;
  final int tekananDarahSistol;
  final int tekananDarahDiastol;

  const CatatBbTensiModelResponseData({
    required this.id,
    required this.nik,
    required this.tanggal,
    required this.beratBadanTerukur,
    required this.tekananDarahSistol,
    required this.tekananDarahDiastol,
  });

  factory CatatBbTensiModelResponseData.fromJson(Map<String, dynamic> json) {
    return CatatBbTensiModelResponseData(
      id: json['id'] ?? 99,
      nik: json['nik'] ?? '',
      tanggal: json['tanggal'] ?? '1990-01-01',
      beratBadanTerukur: json['berat_badan_terukur'] ?? 0,
      tekananDarahSistol: json['tekanan_darah_sistol'] ?? 0,
      tekananDarahDiastol: json['tekanan_darah_diastol'] ?? 0,
    );
  }
}
