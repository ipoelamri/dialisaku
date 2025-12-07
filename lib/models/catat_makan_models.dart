class CatatMakanModelRequest {
  final String waktuMakan;
  final String keteranganMakan;

  const CatatMakanModelRequest({
    required this.waktuMakan,
    required this.keteranganMakan,
  });

  Map<String, dynamic> toJson() {
    return {'waktu_makan': waktuMakan, 'keterangan_makan': keteranganMakan};
  }
}

class CatatMakanModelResponse {
  final String message;
  final CatatMakanModelResponseData? data;

  const CatatMakanModelResponse({required this.message, this.data});

  factory CatatMakanModelResponse.fromJson(Map<String, dynamic> json) {
    return CatatMakanModelResponse(
      message: json['message'],
      data:
          json['data'] != null
              ? CatatMakanModelResponseData.fromJson(json['data'])
              : null,
    );
  }
}

class CatatMakanModelResponseData {
  final String nik;
  final String waktuMakan;
  final String keteranganMakan;

  const CatatMakanModelResponseData({
    required this.nik,
    required this.waktuMakan,
    required this.keteranganMakan,
  });

  factory CatatMakanModelResponseData.fromJson(Map<String, dynamic> json) {
    return CatatMakanModelResponseData(
      nik: json['nik'],
      waktuMakan: json['waktu_makan'],
      keteranganMakan: json['keterangan_makan'],
    );
  }
}
