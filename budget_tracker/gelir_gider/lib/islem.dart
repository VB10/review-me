class Islem {
  final int? id;
  final int tutar;
  final String? aciklama;
  final String? tarih;
  final String tipi;

  Islem({
    this.id,
    required this.tutar,
    this.aciklama,
    this.tarih,
    required this.tipi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tutar': tutar,
      'aciklama': aciklama,
      'tarih': tarih,
      'tipi': tipi,
    };
  }

  factory Islem.fromMap(Map<String, dynamic> map) {
    return Islem(
      id: map['id'],
      tutar: map['tutar'],
      aciklama: map['aciklama'],
      tarih: map['tarih'],
      tipi: map['tipi'],
    );
  }
}
