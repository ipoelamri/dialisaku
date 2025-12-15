import 'package:flutter/foundation.dart';

class PerbaruiJadwalModelRequest {
  final String waktuMakan1;
  final String waktuMakan2;
  final String waktuMakan3;
  final int targetCairanMl;
  final int frekuensiAlarmBbHari;
  final String waktuAlarmBb;

  const PerbaruiJadwalModelRequest({
    required this.waktuMakan1,
    required this.waktuMakan2,
    required this.waktuMakan3,
    required this.targetCairanMl,
    required this.frekuensiAlarmBbHari,
    required this.waktuAlarmBb,
  });

  Map<String, dynamic> toJson() {
    return {
      "waktu_makan_1": waktuMakan1,
      "waktu_makan_2": waktuMakan2,
      "waktu_makan_3": waktuMakan3,
      "target_cairan_ml": targetCairanMl,
      "frekuensi_alarm_bb_hari": frekuensiAlarmBbHari,
      "waktu_alarm_bb": waktuAlarmBb,
    };
  }
}

class PerbaruiJadwalModelResponse {
  final String message;
  final PerbaruiJadwalModelResponseData? data;

  const PerbaruiJadwalModelResponse({required this.message, this.data});

  factory PerbaruiJadwalModelResponse.fromJson(Map<String, dynamic> json) {
    return PerbaruiJadwalModelResponse(
      message: json['message'],
      data: json['data'] != null
          ? PerbaruiJadwalModelResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class PerbaruiJadwalModelResponseData {
  final int id;
  final String nik;
  final String waktuMakan1;
  final String waktuMakan2;
  final String waktuMakan3;
  final int targetCairanMl;
  final int frekuensiAlarmBbHari;
  final String waktuAlarmBb;

  const PerbaruiJadwalModelResponseData({
    required this.id,
    required this.nik,
    required this.waktuMakan1,
    required this.waktuMakan2,
    required this.waktuMakan3,
    required this.targetCairanMl,
    required this.frekuensiAlarmBbHari,
    required this.waktuAlarmBb,
  });
  factory PerbaruiJadwalModelResponseData.fromJson(Map<String, dynamic> json) {
    return PerbaruiJadwalModelResponseData(
      id: json['id'],
      nik: json['nik'] ?? '',
      waktuMakan1: json['waktu_makan_1'] ?? '',
      waktuMakan2: json['waktu_makan_2'] ?? '',
      waktuMakan3: json['waktu_makan_3'] ?? '',
      targetCairanMl: json['target_cairan_ml'] ?? '',
      frekuensiAlarmBbHari: json['frekuensi_alarm_bb_hari'] ?? '',
      waktuAlarmBb: json['waktu_alarm_bb'] ?? '',
    );
  }
}
