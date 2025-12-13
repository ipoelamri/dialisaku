class ModelGetRingkasanResponse {
  final String message;
  final String tanggal;
  final ModelGetRingkasanResponseprofile? profile;
  final ModelGetRingkasanResponseTarget? target;
  final ModelGetRingkasanResponseRealisasi? realisasi;

  ModelGetRingkasanResponse({
    required this.message,
    required this.tanggal,
    this.profile,
    this.target,
    this.realisasi,
  });

  factory ModelGetRingkasanResponse.fromJson(Map<String, dynamic> json) {
    return ModelGetRingkasanResponse(
      message: json['message'] ?? '',
      tanggal: json['tanggal'] ?? '',
      profile:
          json['profil'] != null
              ? ModelGetRingkasanResponseprofile.fromJson(json['profil'])
              : null,
      target:
          json['target'] != null
              ? ModelGetRingkasanResponseTarget.fromJson(json['target'])
              : null,
      realisasi:
          json['realisasi_harian'] != null
              ? ModelGetRingkasanResponseRealisasi.fromJson(json['realisasi_harian'])
              : null,
    );
  }
}

class ModelGetRingkasanResponseprofile {
  final String nama;
  final String nik;
  final String beratBadanAwal;
  const ModelGetRingkasanResponseprofile({
    required this.nama,
    required this.nik,
    required this.beratBadanAwal,
  });

  factory ModelGetRingkasanResponseprofile.fromJson(Map<String, dynamic> json) {
    return ModelGetRingkasanResponseprofile(
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
      beratBadanAwal: json['berat_badan_awal'] ?? '',
    );
  }
}

class ModelGetRingkasanResponseTarget {
  final int cairanMl;
  final String makaPagi;
  final String makanSiang;
  final String makanMalam;
  final String alarmBbHari;

  const ModelGetRingkasanResponseTarget({
    required this.cairanMl,
    required this.makaPagi,
    required this.makanSiang,
    required this.makanMalam,
    required this.alarmBbHari,
  });
  factory ModelGetRingkasanResponseTarget.fromJson(Map<String, dynamic> json) {
    return ModelGetRingkasanResponseTarget(
      cairanMl: json['cairan_ml'] ?? 0,
      makaPagi: json['maka_pagi'] ?? '',
      makanSiang: json['makan_siang'] ?? '',
      makanMalam: json['makan_malam'] ?? '',
      alarmBbHari: json['alarm_bb_hari'] ?? 0,
    );
  }
}

class ModelGetRingkasanResponseRealisasi {
  final int totalMinumMl;
  final int sisaCairanMl;
  final int jmlhMakanDicatat;
  final String beratBadanTerukur;
  final String tekananDarahSistol;
  final String tekananDarahDiastol;
  final String keluhanHariIni;

  const ModelGetRingkasanResponseRealisasi({
    required this.totalMinumMl,
    required this.sisaCairanMl,
    required this.jmlhMakanDicatat,
    required this.beratBadanTerukur,
    required this.tekananDarahSistol,
    required this.tekananDarahDiastol,
    required this.keluhanHariIni,
  });
  factory ModelGetRingkasanResponseRealisasi.fromJson(
    Map<String, dynamic> json,
  ) {
    return ModelGetRingkasanResponseRealisasi(
      totalMinumMl: json['total_minum_ml'] ?? 0,
      sisaCairanMl: json['sisa_cairan_ml'] ?? 0,
      jmlhMakanDicatat: json['jumlah_makan_dicatat'] ?? 0,
      beratBadanTerukur: json['berat_badan_terukur'] ?? '',
      tekananDarahSistol: json['tekanan_darah_sistol'] ?? '',
      tekananDarahDiastol: json['tekanan_darah_diastol'] ?? '',
      keluhanHariIni: json['keluhan_hari_ini'] ?? '',
    );
  }
}
