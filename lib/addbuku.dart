import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'listbuku.dart';

class AddNewBuku extends StatefulWidget {
  const AddNewBuku({super.key});

  @override
  State<AddNewBuku> createState() => _AddNewBukuState();
}

class _AddNewBukuState extends State<AddNewBuku> {
  final _judul = TextEditingController();
  final _penulis = TextEditingController();
  final _kodeBuku = TextEditingController();
  final _kategori = TextEditingController();
  final _jumlah = TextEditingController();
  final _gambar = TextEditingController();
  final _deskripsi = TextEditingController();

  Future<void> addNewBuku() async {
    String urlAddBuku = 'http://10.0.3.2/backend_eperpus/addBuku.php';
    try {
      var responseAddBuku = await http.post(Uri.parse(urlAddBuku), body: {
        "judul": _judul.text.toString(),
        "penulis": _penulis.text.toString(),
        "kode_buku": _kodeBuku.text.toString(),
        "kategori": _kategori.text.toString(),
        "jumlah": _jumlah.text.toString(),
        "gambar": _gambar.text.toString(),
        "deskripsi": _deskripsi.text.toString(),
      });
      var bodyAdd = json.decode(responseAddBuku.body);
      if (bodyAdd == "true") {
        if (kDebugMode) {
          print("Buku Baru Berhasil Ditambahkan");
        }
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const ListBuku()));
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            )),
        title: const Text(
          "Tambah Buku Baru",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: TextField(
                  controller: _judul,
                  decoration: const InputDecoration(
                    labelText: "Entri Judul Buku",
                    hintText: "entri judul buku",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.title,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextField(
                  controller: _penulis,
                  decoration: const InputDecoration(
                    labelText: "Entri Penulis Buku",
                    hintText: "entri penulis",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(CupertinoIcons.person_crop_rectangle,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextField(
                  controller: _kodeBuku,
                  decoration: const InputDecoration(
                    labelText: "Entri Kode Buku",
                    hintText: "entri kode",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.abc,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextField(
                  controller: _kategori,
                  decoration: const InputDecoration(
                    labelText: "Entri Kategori Buku",
                    hintText: "entri kategori",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.category,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextField(
                  controller: _jumlah,
                  decoration: const InputDecoration(
                    labelText: "Entri Jumlah Buku",
                    hintText: "entri jumlah",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(CupertinoIcons.list_number,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextField(
                  controller: _deskripsi,
                  decoration: const InputDecoration(
                    labelText: "Entri Deskripsi Buku",
                    hintText: "entri deskripsi",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.description,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 35),
                child: TextField(
                  controller: _gambar,
                  decoration: const InputDecoration(
                    labelText: "Entri URL Gambar",
                    hintText: "entri url gambar",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 96, 90, 157),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 97, 103, 152),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.link,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    addNewBuku();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListBuku()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
