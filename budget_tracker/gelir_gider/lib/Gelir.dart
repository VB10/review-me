import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'islemlerDao.dart';
import 'islem.dart';
import 'Gelir_ekle.dart';
import 'VeriTabaniYardımci.dart';


class Gelir_Sayfasi extends StatefulWidget {
  const Gelir_Sayfasi({super.key});

  @override
  State<Gelir_Sayfasi> createState() => _Gelir_SayfasiState();
}

class _Gelir_SayfasiState extends State<Gelir_Sayfasi> {
  List<Islem> gelirler = [];

  final formatter = NumberFormat.decimalPattern('tr_TR');

  int get toplamGelir {
    return gelirler.fold(0, (toplam, gelir) => toplam + gelir.tutar);
  }

  @override
  void initState() {
    super.initState();
    gelirleriYukle();
  }

  Future<void> gelirleriYukle() async {
    final tumIslemler = await IslemlerDao().tumIslemler();
    setState(() {
      gelirler = tumIslemler.where((i) => i.tipi == "Gelir").toList();
    });
  }

  Future<void> _gelirSil(int index) async {
    final bool? onay = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2F3359),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Emin misiniz?", style: TextStyle(color: Colors.white)),
        content: Text(
          "Bu geliri silmek istediğinize emin misiniz?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text("İptal", style: TextStyle(color: Colors.grey[400])),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Sil", style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (onay == true) {
      final islem = gelirler[index];
      final db = await VeriTabaniYardimcisi.veritabaniErisim();
      await db.delete('islemler', where: 'id = ?', whereArgs: [islem.id]);

      setState(() {
        gelirler.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF21254A),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Text(
              "Gelirlerim",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: gelirler.isEmpty
                ? Center(
                    child: Text(
                      "Henüz Gelir Girilmedi.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: gelirler.length,
                    itemBuilder: (context, index) {
                      var gelir = gelirler[index];
                      return Stack(
                        children: [
                          Card(
                            color: Color(0xff31274f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              title: Text(
                                gelir.aciklama ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                gelir.tarih ?? '',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: Text(
                                "+${formatter.format(gelir.tutar)} ₺",
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => _gelirSil(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF7E57C2),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                final bool? kayitYapildi = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => gelirEkle()),
                );

                if (kayitYapildi == true) {
                  await gelirleriYukle();
                }
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Gelir Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff31274f),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
