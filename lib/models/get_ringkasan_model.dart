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
      nama: json['nama']?.toString() ?? '',
      nik: json['nik']?.toString() ?? '',
      beratBadanAwal: json['berat_badan_awal']?.toString() ?? '',
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
      cairanMl: int.tryParse(json['cairan_ml']?.toString() ?? '0') ?? 0,
      makaPagi: json['maka_pagi']?.toString() ?? '',
      makanSiang: json['makan_siang']?.toString() ?? '',
      makanMalam: json['makan_malam']?.toString() ?? '',
      alarmBbHari: json['alarm_bb_hari']?.toString() ?? '',
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
      totalMinumMl: int.tryParse(json['total_minum_ml']?.toString() ?? '0') ?? 0,
      sisaCairanMl: int.tryParse(json['sisa_cairan_ml']?.toString() ?? '0') ?? 0,
      jmlhMakanDicatat:
          int.tryParse(json['jumlah_makan_dicatat']?.toString() ?? '0') ?? 0,
      beratBadanTerukur: json['berat_badan_terukur']?.toString() ?? '',
      tekananDarahSistol: json['tekanan_darah_sistol']?.toString() ?? '',
      tekananDarahDiastol: json['tekanan_darah_diastol']?.toString() ?? '',
      keluhanHariIni: json['keluhan_hari_ini']?.toString() ?? '',
    );
  }
}
