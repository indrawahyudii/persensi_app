import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_app/model/presensi.dart';
import 'package:presensi_app/screen/attandance_recap_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String nik = "", token = "", name = "", dept = "", imgUrl = "";
  bool isMasuk = true;

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? nik = prefs.getString('nik') ?? "";
    String? token = prefs.getString('jwt') ?? "";
    String? name = prefs.getString('name') ?? "";
    String? dept = prefs.getString('dept') ?? "";
    String? imgUrl = prefs.getString('imgProfil') ?? "not found";

    setState(() {
      this.nik = nik;
      this.token = token;
      this.name = name;
      this.dept = dept;
      this.imgUrl = imgUrl;
    });
  }

  //get presence info
  Future<Presensi> fetchPresensi(String nik, String tanggal) async {
    String url =
        'https://presensi.spilme.id/presence?nik=$nik&tanggal=$tanggal';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});

    // Metode untuk menyimpan status check-in/check-out
    Future<void> saveStatusMasuk() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isMasuk', isMasuk);
    }

    // Metode untuk memuat status check-in/check-out
    Future<void> loadStatusMasuk() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isMasuk = prefs.getBool('isMasuk') ?? true;
      });
    }

    Future<void> recordAttendance() async {
      //tutup showbottomsheet
      Navigator.pop(context);
      //end point
      const String endpointMasuk = 'https://presensi.spilme.id/entry';
      const String endpointKeluar = 'https://presensi.spilme.id/exit';

      final endpoint = isMasuk ? endpointMasuk : endpointKeluar;
      final requestBody = isMasuk
          ? {
              'nik': nik,
              'tanggal': getTodayDate(),
              'jam_masuk': getTime(),
              'lokasi_masuk': 'polbeng',
            }
          : {
              'nik': nik,
              'tanggal': getTodayDate(),
              'jam_keluar': getTime(),
              'lokasi_keluar': 'polbeng',
            };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
        setState(() {
          isMasuk = !isMasuk;
          saveStatusMasuk(); // simpan status absensi
        });
        //refresh informasi absensi
        fetchPresensi(nik, getTodayDate());
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to record attendance')),
        );
      }
    }

    if (response.statusCode == 200) {
      return Presensi.fromJson(jsonDecode(response.body));
    } else {
      //jika data tidak tersedia, buat data default
      return Presensi(
        id: 0,
        nik: this.nik,
        tanggal: getTodayDate(),
        jamMasuk: "--:--",
        jamKeluar: '--:--',
        lokasiMasuk: '-',
        lokasiKeluar: '-',
        status: '-',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    loadStatusMasuk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 163, 162, 162),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              //Greetings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(imgUrl,
                            height: 84, fit: BoxFit.cover)),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 10),
              FutureBuilder<Presensi>(
                future: futurePresensi,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 219, 226, 228),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  35, 48, 134, 254),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: SvgPicture.asset(
                                              'assets/svgs/login_outlined.svg'),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Masuk',
                                          style: GoogleFonts.lexend(
                                            fontSize: 16,
                                            color: const Color(0xFF101317),
                                          ),
                                        )
                                      ]),
                                      const SizedBox(height: 10),
                                      Text(
                                        data.jamMasuk,
                                        style: GoogleFonts.lexend(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                      Text(
                                        getPresenceEntryStatus(
                                            data?.jamMasuk ?? '-'),
                                        style: GoogleFonts.lexend(
                                          fontSize: 16,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 219, 226, 228),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  35, 48, 134, 254),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: SvgPicture.asset(
                                              'assets/svgs/logout_outlined.svg'),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Tekan untuk presensi ${isMasuk ? 'masuk' : 'pulang'}',
                                          style: GoogleFonts.lexend(
                                            fontSize: 16,
                                            color: const Color(0xFF101317),
                                          ),
                                        )
                                      ]),
                                      const SizedBox(height: 10),
                                      Text(
                                        data.jamKeluar,
                                        style: GoogleFonts.lexend(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                      Text(
                                        getPresenceExitStatus(data.jamKeluar),
                                        style: GoogleFonts.lexend(
                                          fontSize: 16,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Izin Absen Card
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/card_bg.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Izin Absen',
                                        style: GoogleFonts.lexend(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Ajukan izin absen Anda',
                                        style: GoogleFonts.lexend(
                                          fontSize: 14,
                                          color: const Color(0xFF101317),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Action on button press
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF12A3DA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Ajukan',
                                      style: GoogleFonts.lexend(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('Tidak ada data presensi.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getTodayDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String getPresenceEntryStatus(String jamMasuk) {
  // Implementasikan logika status kehadiran masuk sesuai kebutuhan
  return 'On Time'; // Contoh pengembalian status
}

String getPresenceExitStatus(String jamKeluar) {
  // Implementasikan logika status kehadiran keluar sesuai kebutuhan
  return 'Left Early'; // Contoh pengembalian status
}
