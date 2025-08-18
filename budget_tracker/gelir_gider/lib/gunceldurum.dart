import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'IslemlerDao.dart';

class gunceldurum extends StatefulWidget {
  const gunceldurum({Key? key}) : super(key: key);

  @override
  State<gunceldurum> createState() => _gunceldurumState();
}

class _gunceldurumState extends State<gunceldurum> {
  int toplamGelir = 0;
  int toplamGider = 0;

  final formatter = NumberFormat.decimalPattern('tr_TR');

  @override
  void initState() {
    super.initState();
    _gelirVeGiderleriGetir();
  }

  Future<void> _gelirVeGiderleriGetir() async {
    final dao = IslemlerDao();
    int gelir = await dao.toplamTutarByTipi("Gelir");
    int gider = await dao.toplamTutarByTipi("Gider");

    setState(() {
      toplamGelir = gelir;
      toplamGider = gider;
    });
  }

  @override
  Widget build(BuildContext context) {
    final netDurum = toplamGelir - toplamGider;
    final bool kardaMi = netDurum >= 0;

    return Scaffold(
      backgroundColor: Color(0xFF21254A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2A2A40),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff6f3dd1),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRowItem(
                      label: "Toplam Gelir",
                      amount: toplamGelir,
                      icon: Icons.arrow_upward,
                      iconColor: Colors.greenAccent,
                    ),
                    Divider(color: Colors.white12, height: 40, thickness: 1),
                    _buildRowItem(
                      label: "Toplam Gider",
                      amount: toplamGider,
                      icon: Icons.arrow_downward,
                      iconColor: Colors.redAccent,
                    ),
                    SizedBox(height: 40),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: kardaMi ? Color(0xFF2E7D32) : Color(0xFFDD2C00),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kardaMi
                                ? Colors.greenAccent.withOpacity(0.6)
                                : Colors.redAccent.withOpacity(0.6),
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            kardaMi ? Icons.trending_up : Icons.trending_down,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            child: Text(
                              '${kardaMi ? "Kâr" : "Zarar"}: ${formatter.format(netDurum.abs())} ₺',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF2F3359),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_graph, color: Colors.white54, size: 30),
                    Text(
                      "Gelir ve giderlerini düzenli takip et,\nbütçeni güçlendir!",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.white30),
                    SizedBox(height: 5),
                    Text(
                      "Unutma: Küçük farkındalıklar, büyük finansal değişimlere yol açar.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem({
    required String label,
    required int amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.3),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          "${formatter.format(amount)} ₺",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
