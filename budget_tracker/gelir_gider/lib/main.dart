import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gelir_gider/hesapOlustur.dart';
import 'package:gelir_gider/KisilerDao.dart';
import 'package:gelir_gider/Kullaniciler.dart';
import 'package:gelir_gider/AnaSayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(),
      initialRoute: '/MyHomePage',
      routes: {
        '/MyHomePage': (context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        '/AnaSayfa': (context) => const AnaSayfa(),
        '/HesapOlustur': (context) => const HesapOlustur(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController kullaniciAdiController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  Future<void> KullanicileriGoster() async {
    var liste = await KisilerDao().tumKullaniciler();

    for (Kullaniciler k in liste) {
      print("*****************");
      print("Kisi id :  ${k.kisi_id}");
      print("Kisi Ad :  ${k.kisi_ad}");
      print("Kisi Kullanıcı Adı :  ${k.kisi_kullaniciadi}");
      print("Kisi Şifre :  ${k.kisi_sifre}");
      print("Kisi Soyad:  ${k.kisi_soyad}");
    }
  }

  @override
  void initState() {
    super.initState();
    KullanicileriGoster();
  }

  bool _sifreGoster = false;

  final _kullaniciAdiFocus = FocusNode();
  final _sifreFocus = FocusNode();

  @override
  void dispose() {
    kullaniciAdiController.dispose();
    sifreController.dispose();
    _kullaniciAdiFocus.dispose();
    _sifreFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * .20,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("resimler/topImage.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Merhaba \nHoşgeldin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customSizedBox(),

                    TextFormField(
                      controller: kullaniciAdiController,
                      style: const TextStyle(color: Colors.white),
                      decoration: customInputDecoration("Kullanıcı Adı"),
                      focusNode: _kullaniciAdiFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_sifreFocus);
                      },
                    ),
                    customSizedBox(),

                    TextFormField(
                      controller: sifreController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: !_sifreGoster,
                      decoration: InputDecoration(
                        hintText: "Şifre",
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        counterStyle: const TextStyle(color: Colors.grey),
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
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: _sifreFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _sifreFocus.unfocus();
                      },
                    ),
                    customSizedBox(),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Şifremi Unuttum!",
                          style: TextStyle(color: Colors.pink[200]),
                        ),
                      ),
                    ),
                    customSizedBox(),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          String kullaniciAdi = kullaniciAdiController.text
                              .trim();
                          String sifre = sifreController.text.trim();

                          if (kullaniciAdi.isEmpty || sifre.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Lütfen kullanıcı adı ve şifreyi girin",
                                ),
                              ),
                            );
                            return;
                          }

                          bool girisBasarili = await KisilerDao()
                              .kullaniciKontrol(kullaniciAdi, sifre);

                          if (girisBasarili) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/AnaSayfa',
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Kullanıcı adı veya şifre yanlış",
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff31274f),
                          ),
                          child: const Center(
                            child: Text(
                              "Giriş Yap",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                    customSizedBox(),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/HesapOlustur');
                        },
                        child: Text(
                          "Hesap Oluştur!",
                          style: TextStyle(color: Colors.pink[200]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(height: 20);

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }
}
