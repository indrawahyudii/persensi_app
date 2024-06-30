import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_app/screen/attandance_recap_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String token;
  late String name;
  late String dept;
  late String imgUrl;

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt') ?? "";
    String? name = prefs.getString('name') ?? "";
    String? dept = prefs.getString('dept') ?? "";
    String? imgUrl = prefs.getString('imgProfil') ?? "not found";

    setState(() {
      this.token = token;
      this.name = name;
      this.dept = dept;
      this.imgUrl = imgUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 163, 162, 162),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            //Greetings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          Image.network(imgUrl, height: 84, fit: BoxFit.cover)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          color: const Color(0xFF263238),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dept,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: const Color(0xFF263238),
                        ),
                      ),
                    ],
                  )
                ]),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                      iconSize: 32,
                      color: Colors.black,
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: const Color(0xFFEF6497),
                              borderRadius: BorderRadius.circular(15 / 2)),
                          child: Center(
                              child: Text(
                            "99+",
                            style: GoogleFonts.mPlus1p(
                                color: Colors.white,
                                fontSize: 5,
                                fontWeight: FontWeight.w800),
                          ))),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kehadiran hari ini',
                  style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: const Color(0xFF101317),
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AttandanceRecapScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Rekap Absensi',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: const Color(0xFF12A3DA),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg_izin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Izin Absen',
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Isi form untuk mengajukan izin absensi',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xff313638),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text(
                                'Ajukan izin',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg_cuti.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Izin Cuti',
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Isi form untuk mengajukan cuti',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xff9B59B6),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text(
                                'Ajukan Cuti',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget attandanceScreen() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Presensi Masuk',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Color(0xffE74C3C),
                  size: 32,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal Masuk',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff111111),
                        )),
                    Text('Selasa, 23 Agustus 2023',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: const Color(0xff707070),
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.av_timer_outlined,
                  color: Color(0xffE74C3C),
                  size: 32,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jam Masuk',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff111111),
                        )),
                    Text('07:30:23',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: const Color(0xff707070),
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Foto selfie di area kantor',
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: const Color(0xff707070),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Container(
                height: 200, // Set your desired height
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ambil Gambar'),
                  onPressed: () {
                    // Implement your image picking logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement your check-in logic
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Hadir',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
