import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'islemlerDao.dart';
import 'islem.dart';
import 'Gider_ekle.dart';
import 'VeriTabaniYardımci.dart';

class Gider_Sayfasi extends StatefulWidget {
  const Gider_Sayfasi({super.key});

  @override
  State<Gider_Sayfasi> createState() => _Gider_SayfasiState();
}

class _Gider_SayfasiState extends State<Gider_Sayfasi> {
  List<Islem> giderler = [];

  final formatter = NumberFormat.decimalPattern('tr_TR');

  @override
  void initState() {
    super.initState();
    giderleriYukle();
  }

  Future<void> giderleriYukle() async {
    final tumIslemler = await IslemlerDao().tumIslemler();
    setState(() {
      giderler = tumIslemler
          .where((i) => i.tipi.toLowerCase() == "gider")
          .toList();
    });
  }

  Future<void> _giderSil(int index) async {
    final bool? onay = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2F3359),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Emin misiniz?", style: TextStyle(color: Colors.white)),
        content: Text(
          "Bu gideri silmek istediğinize emin misiniz?",
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
      final islem = giderler[index];
      final db = await VeriTabaniYardimcisi.veritabaniErisim();
      await db.delete('islemler', where: 'id = ?', whereArgs: [islem.id]);

      setState(() {
        giderler.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF21254A),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Giderlerim",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),

          Expanded(
            child: giderler.isEmpty
                ? Center(
                    child: Text(
                      "Henüz Gider Girilmedi.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: giderler.length,
                    itemBuilder: (context, index) {
                      var gider = giderler[index];
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
                                gider.aciklama ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                gider.tarih ?? '',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: Text(
                                "-${formatter.format(gider.tutar)} ₺",
                                style: TextStyle(
                                  color: Colors.redAccent,
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
                              onTap: () => _giderSil(index),
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
                final sonuc = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => giderEkle()),
                );

                if (sonuc == true) {
                  await giderleriYukle();
                }
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Gider Ekle"),
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
