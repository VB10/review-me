import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeriTabaniYardimcisi {
  static final String veritabaniAdi = "gelir_gider_db.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    if (await databaseExists(veritabaniYolu)) {
      print("Veritabanı zaten var kopyalamaya gerek yok!");
    } else {
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");

      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      print("Veritabanı Kopyalandı");
    }

    return openDatabase(
      veritabaniYolu,
      version: 1,
      onCreate: (db, version) async {
        print("Veritabanı oluşturuluyor...");
        await db.execute('''
          CREATE TABLE islemler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tutar INTEGER NOT NULL,
            aciklama TEXT,
            tarih TEXT,
            tipi TEXT
          )
        ''');
        print("Tablo oluşturuldu.");
      },
    );
  }
}
