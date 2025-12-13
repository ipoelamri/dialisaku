class CatatMinumModelRequest {
  final String waktuMinum;
  final String jumlahMl;
  final String jenisCairan;

  const CatatMinumModelRequest({
    required this.waktuMinum,
    required this.jumlahMl,
    required this.jenisCairan,
  });

  Map<String, dynamic> toJson() {
    return {
      'waktu_minum': waktuMinum,
      'jumlah_ml': jumlahMl,
      'jenis_cairan': jenisCairan,
    };
  }
}

class CatatMinumModelResponse {
  final String message;
  final CatatMinumModelResponseData? data;

  const CatatMinumModelResponse({required this.message, this.data});

  factory CatatMinumModelResponse.fromJson(Map<String, dynamic> json) {
    return CatatMinumModelResponse(
      message: json['message'],
      data: json['data'] != null
          ? CatatMinumModelResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class CatatMinumModelResponseData {
  final String nik;
  final String waktuMinum;
  final String jumlahMl;

  const CatatMinumModelResponseData({
    required this.nik,
    required this.waktuMinum,
    required this.jumlahMl,
  });

  factory CatatMinumModelResponseData.fromJson(Map<String, dynamic> json) {
    return CatatMinumModelResponseData(
      nik: json['nik'],
      waktuMinum: json['waktu_minum'],
      jumlahMl: json['jumlah_ml'],
    );
  }
}
