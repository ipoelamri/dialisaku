class ModelGetJadwalResponse {
  final String message;
  final ModelGetJadwaResponseData? data;

  ModelGetJadwalResponse({required this.message, this.data});

  factory ModelGetJadwalResponse.fromJson(Map<String, dynamic> json) {
    return ModelGetJadwalResponse(
      message: json['message'],
      data: json['data'] != null
          ? ModelGetJadwaResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class ModelGetJadwaResponseData {
  final int id;
  final String nik;
  final String waktuMakan1;
  final String waktuMakan2;
  final String waktuMakan3;
  final int targetCairanMl;
  final int frekuensiAlarmBbHari;
  final String waktuAlarmBb;

  const ModelGetJadwaResponseData({
    required this.id,
    required this.nik,
    required this.waktuMakan1,
    required this.waktuMakan2,
    required this.waktuMakan3,
    required this.targetCairanMl,
    required this.frekuensiAlarmBbHari,
    required this.waktuAlarmBb,
  });

  factory ModelGetJadwaResponseData.fromJson(Map<String, dynamic> json) {
    return ModelGetJadwaResponseData(
      id: json['id'],
      nik: json['nik'],
      waktuMakan1: json['waktu_makan_1'],
      waktuMakan2: json['waktu_makan_2'],
      waktuMakan3: json['waktu_makan_3'],
      targetCairanMl: int.parse(json['target_cairan_ml']),
      frekuensiAlarmBbHari: int.parse(json['frekuensi_alarm_bb_hari']),
      waktuAlarmBb: json['waktu_alarm_bb'],
    );
  }
}