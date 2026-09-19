class SesiPertemuan {
  final DateTime tanggal;
  bool selesai;

  SesiPertemuan({required this.tanggal, this.selesai = false});
}

class JadwalKursusItem {
  String namaKelas;
  String jam;
  String instruktur;
  String peserta;
  List<SesiPertemuan> sesiList;

  JadwalKursusItem({
    required this.namaKelas,
    required this.jam,
    required this.instruktur,
    required this.peserta,
    required this.sesiList,
  });

  int get totalSelesai => sesiList.where((s) => s.selesai).length;
  int get totalPertemuan => sesiList.length;
}