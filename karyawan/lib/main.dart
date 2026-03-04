import 'package:flutter/material.dart';
import '../models/karyawan.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Karyawan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Karyawan>> loadKaryawan() async {
    final String response = await rootBundle.loadString('assets/karyawan.json');
    final List<dynamic> data = jsonDecode(response);
    return Karyawan.fromJsonList(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Karyawan"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<List<Karyawan>>(
        future: loadKaryawan(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ada"));
          }

          final karyawanList = snapshot.data!;

          return ListView.builder(
            itemCount: karyawanList.length,
            itemBuilder: (context, index) {

              final karyawan = karyawanList[index];

              return ListTile(
                title: Text(karyawan.nama),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Umur: ${karyawan.umur}"),
                    Text(
                      "Alamat: ${karyawan.alamat.jalan}, "
                      "${karyawan.alamat.kota}, "
                      "${karyawan.alamat.provinsi}",
                    ),
                    Text("Hobi: ${karyawan.hobi.join(', ')}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}