import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelir_gider/KisilerDao.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({super.key});

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

final adController = TextEditingController();
final soyadController = TextEditingController();
final kullaniciAdiController = TextEditingController();
final sifreController = TextEditingController();

class _HesapOlusturState extends State<HesapOlustur> {
  bool _sifreGoster = false;

  final FocusNode _adFocus = FocusNode();
  final FocusNode _soyadFocus = FocusNode();
  final FocusNode _kullaniciAdiFocus = FocusNode();
  final FocusNode _sifreFocus = FocusNode();

  @override
  void dispose() {
    _adFocus.dispose();
    _soyadFocus.dispose();
    _kullaniciAdiFocus.dispose();
    _sifreFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(""),
        backgroundColor: Color(0xFF21254A),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF21254A),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  customSizedBox(),

                  TextFormField(
                    controller: adController,
                    focusNode: _adFocus,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ad",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_soyadFocus);
                    },
                  ),
                  customSizedBox(),

                  TextFormField(
                    controller: soyadController,
                    focusNode: _soyadFocus,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Soyad",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_kullaniciAdiFocus);
                    },
                  ),
                  customSizedBox(),

                  TextFormField(
                    controller: kullaniciAdiController,
                    focusNode: _kullaniciAdiFocus,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Kullanıcı Adı",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.verified_user, color: Colors.grey),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_sifreFocus);
                    },
                  ),
                  customSizedBox(),

                  TextFormField(
                    controller: sifreController,
                    focusNode: _sifreFocus,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: !_sifreGoster,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(
                        Icons.password_sharp,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _sifreGoster
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _sifreGoster = !_sifreGoster;
                          });
                        },
                      ),
                      counterStyle: TextStyle(color: Colors.grey),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  customSizedBox(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        String ad = adController.text.trim();
                        String soyad = soyadController.text.trim();
                        String kullaniciAdi = kullaniciAdiController.text
                            .trim();
                        String sifre = sifreController.text.trim();

                        if (ad.isEmpty ||
                            soyad.isEmpty ||
                            kullaniciAdi.isEmpty ||
                            sifre.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Lütfen tüm alanları doldurun!"),
                            ),
                          );
                          return;
                        }
                        bool sonuc = await KisilerDao().kullaniciEkle(
                          ad,
                          soyad,
                          kullaniciAdi,
                          sifre,
                        );

                        if (sonuc) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt başarılı!")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt başarısız!")),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff31274f),
                        ),
                        child: Center(
                          child: Text(
                            "Oluştur",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(
                "resimler/topImage.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customSizedBox() => SizedBox(height: 20);
}

InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
  );
}
