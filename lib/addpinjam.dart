import 'dart:convert';
import 'package:eperpus_sakinah/listpinjam.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewPinjam extends StatefulWidget {
  const AddNewPinjam({super.key});

  @override
  State<AddNewPinjam> createState() => _AddNewPinjamState();
}

class _AddNewPinjamState extends State<AddNewPinjam> {
  final _namaPeminjam = TextEditingController();
  String? _bukuId;
  DateTime? _tglPinjam;
  final _tglPinjamController = TextEditingController();
  List<Map<String, dynamic>> _bukuList = [];

  Future<void> fetchBuku() async {
    String urlBuku = 'http://10.0.3.2/backend_eperpus/listBuku.php';
    try {
      var response = await http.get(Uri.parse(urlBuku));
      if (kDebugMode) {
        print("Response body: ${response.body}");
      }
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _bukuList = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load buku');
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> addNewPinjam() async {
    String urlAddPinjam = 'http://10.0.3.2/backend_eperpus/addPinjam.php';
    try {
      var responseAddPinjam = await http.post(Uri.parse(urlAddPinjam), body: {
        "nama_peminjam": _namaPeminjam.text.toString(),
        "buku_id": _bukuId!,
        "tanggal_peminjaman": _tglPinjam!.toIso8601String(),
      });
      if (kDebugMode) {
        print("Response body: ${responseAddPinjam.body}");
      }
      var bodyAdd = json.decode(responseAddPinjam.body);
      if (bodyAdd['message'] == 'peminjaman baru sukses ditambahkan') {
        if (kDebugMode) {
          print("");
        }
      } else {
        if (kDebugMode) {
          print("");
        }
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const ListPinjam()));
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            )),
        title: const Text(
          "Peminjaman Baru",
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
                  controller: _namaPeminjam,
                  decoration: const InputDecoration(
                    labelText: "Entri nama peminjam",
                    hintText: "entri nama peminjam",
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
                      child: Icon(Icons.person,
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
                child: DropdownButtonFormField<String>(
                  value: _bukuId,
                  hint: const Text('Pilih Judul Buku'),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 96, 90, 157),
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  items: _bukuList
                      .map((buku) => DropdownMenuItem(
                            value: buku['id'].toString(),
                            child: Text(buku['judul']),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _bukuId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.book,
                          color: Color.fromARGB(255, 97, 103, 152)),
                    ),
                    fillColor: Color.fromARGB(255, 224, 234, 255),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  isExpanded: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Entri tanggal pinjam",
                    hintText: "entri tanggal pinjam",
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
                      child: Icon(Icons.date_range,
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
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _tglPinjam = pickedDate;
                        _tglPinjamController.text = _tglPinjam!.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  controller: _tglPinjamController,
                ),
              ),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (_bukuId != null && _tglPinjam != null) {
                      addNewPinjam();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListPinjam()),
                      );
                    }
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