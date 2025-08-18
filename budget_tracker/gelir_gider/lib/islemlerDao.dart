import 'islem.dart';
import 'VeriTabaniYardımci.dart';

class IslemlerDao {
  Future<void> silIslem(int id) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    await db.delete('islemler', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertIslem(Islem islem) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    return await db.insert('islemler', islem.toMap());
  }

  Future<List<Islem>> tumIslemler() async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final maps = await db.query('islemler', orderBy: 'tarih DESC');
    return List.generate(maps.length, (i) => Islem.fromMap(maps[i]));
  }

  Future<int> toplamTutarByTipi(String tipi) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final result = await db.rawQuery(
      'SELECT SUM(tutar) as toplam FROM islemler WHERE tipi = ?',
      [tipi],
    );

    return result.first['toplam'] == null ? 0 : result.first['toplam'] as int;
  }

  Future<bool> islemEkle(Islem islem) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();
    try {
      await db.insert('islemler', {
        'tutar': islem.tutar,
        'aciklama': islem.aciklama,
        'tarih': islem.tarih,
        'tipi': islem.tipi,
      });
      return true;
    } catch (e) {
      print("Veri ekleme hatası: $e");
      return false;
    }
  }
}
