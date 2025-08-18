import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'islemlerDao.dart';
import 'islem.dart';

class gelirEkle extends StatefulWidget {
  const gelirEkle({super.key});

  @override
  State<gelirEkle> createState() => _gelirEkleState();
}

class _gelirEkleState extends State<gelirEkle> {
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _tutarController = TextEditingController();
  DateTime? _secilenTarih;

  final _formatter = ThousandsFormatter();

  @override
  void dispose() {
    _aciklamaController.dispose();
    _tutarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21254A),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF21254A),
      ),
      body: Stack(
        children: [
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
          Align(
            alignment: Alignment(0, -0.5),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff31274f),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  _buildTextField(
                    "Açıklama",
                    _aciklamaController,
                    icon: Icons.edit_note,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Tutar (₺)",
                    _tutarController,
                    icon: Icons.account_balance_wallet,
                    isNumeric: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _formatter,
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildDatePicker(context),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_aciklamaController.text.isEmpty ||
                          _tutarController.text.isEmpty ||
                          _secilenTarih == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Lütfen tüm alanları doldurun"),
                          ),
                        );
                        return;
                      }

                      String tutarString = _tutarController.text.replaceAll(
                        '.',
                        '',
                      );
                      int tutarInt = int.tryParse(tutarString) ?? 0;

                      Islem yeniIslem = Islem(
                        id: null,
                        tutar: tutarInt,
                        aciklama: _aciklamaController.text,
                        tarih:
                            "${_secilenTarih!.day}.${_secilenTarih!.month}.${_secilenTarih!.year}",
                        tipi: "Gelir",
                      );

                      bool sonuc = await IslemlerDao().islemEkle(yeniIslem);

                      if (sonuc) {
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Veri kaydedilirken hata oluştu."),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text(
                      "Kaydet",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    IconData? icon,
    bool isNumeric = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.white60) : null,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Color(0xFF2e2b50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.date_range, color: Colors.white70),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            _secilenTarih == null
                ? "Tarih seçilmedi"
                : "${_secilenTarih!.day}.${_secilenTarih!.month}.${_secilenTarih!.year}",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        TextButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) =>
                  Theme(data: ThemeData.dark(), child: child!),
            );

            if (picked != null) {
              setState(() {
                _secilenTarih = picked;
              });
            }
          },
          child: Text("Tarih Seç"),
        ),
      ],
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String onlyNumbers = newValue.text.replaceAll('.', '');
    if (onlyNumbers.isEmpty) return newValue.copyWith(text: '');

    int value = int.parse(onlyNumbers);
    final newString = _formatNumber(value);

    int selectionIndex =
        newString.length - (oldValue.text.length - oldValue.selection.end);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: selectionIndex < 0 ? 0 : selectionIndex,
      ),
    );
  }

  String _formatNumber(int number) {
    final chars = number.toString().split('').reversed.toList();
    final List<String> newChars = [];
    for (int i = 0; i < chars.length; i++) {
      newChars.add(chars[i]);
      if ((i + 1) % 3 == 0 && i != chars.length - 1) {
        newChars.add('.');
      }
    }
    return newChars.reversed.join('');
  }
}
