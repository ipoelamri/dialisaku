class CatatMakanModelRequest {
  final String waktuMakan;
  String? keteranganMakan;

  CatatMakanModelRequest({required this.waktuMakan, this.keteranganMakan});

  Map<String, dynamic> toJson() {
    return {'waktu_makan': waktuMakan, 'keterangan_makanan': keteranganMakan};
  }
}

class CatatMakanModelResponse {
  final String message;
  final CatatMakanModelResponseData? data;

  const CatatMakanModelResponse({required this.message, this.data});

  factory CatatMakanModelResponse.fromJson(Map<String, dynamic> json) {
    return CatatMakanModelResponse(
      message: json['message'],
      data: json['data'] != null
          ? CatatMakanModelResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class CatatMakanModelResponseData {
  final String nik;
  final String waktuMakan;
  final String keteranganMakanan;

  const CatatMakanModelResponseData({
    required this.nik,
    required this.waktuMakan,
    required this.keteranganMakanan,
  });

  factory CatatMakanModelResponseData.fromJson(Map<String, dynamic> json) {
    return CatatMakanModelResponseData(
      nik: json['nik'],
      waktuMakan: json['waktu_makan'],
      keteranganMakanan: json['keterangan_makanan'],
    );
  }
}
