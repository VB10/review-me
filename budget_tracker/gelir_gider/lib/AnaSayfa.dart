import 'package:flutter/material.dart';
import 'package:gelir_gider/Gider.dart';
import 'package:gelir_gider/gunceldurum.dart';
import 'Gelir.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  var sayfaListesi = [Gelir_Sayfasi(), gunceldurum(), Gider_Sayfasi()];

  int secilenIndeks = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21254A),
      body: Column(
        children: [
          Container(
            height: 185,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("resimler/topImage.png"),
              ),
            ),
          ),
          Expanded(child: sayfaListesi[secilenIndeks]),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: "Gelirlerim",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Mevcut Durumum",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_down),
              label: "Giderlerim",
            ),
          ],
          backgroundColor: Color(0xFF21254A),
          unselectedItemColor: Colors.white30,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          iconSize: 45,
          elevation: 0,
          currentIndex: secilenIndeks,
          onTap: (indeks) {
            setState(() {
              secilenIndeks = indeks;
            });
          },
        ),
      ),
    );
  }
}
