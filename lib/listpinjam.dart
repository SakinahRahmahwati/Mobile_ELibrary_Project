import 'dart:convert';
import 'package:eperpus_sakinah/addpinjam.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListPinjam extends StatefulWidget {
  const ListPinjam({super.key});

  @override
  State<ListPinjam> createState() => _ListPinjamState();
}

class _ListPinjamState extends State<ListPinjam> {
  @override
  void initState() {
    super.initState();
    getAllPinjam();
  }

  final TextEditingController searchController = TextEditingController();
  List listPinjam = [];

  Future<void> getAllPinjam() async {
    String urlListPinjam = "http://10.0.3.2/backend_eperpus/listPinjam.php";
    var response = await http.get(Uri.parse(urlListPinjam));
    try {
      setState(() {
        listPinjam = jsonDecode(response.body).map((item) {
          item['isReturned'] =
              item['isReturned'] ?? false;
          return item;
        }).toList();
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> searchPinjam() async {
    String urlSearchPinjam =
        "http://10.0.3.2/backend_eperpus/searchPinjam.php?query=${searchController.text}";
    try {
      var responseSearch = await http.get(Uri.parse(urlSearchPinjam));
      final List bodySearch = json.decode(responseSearch.body);
      setState(() {
        listPinjam = bodySearch.map((item) {
          item['isReturned'] = (item['isReturned'] == true);
          return item;
        }).toList();
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> deletePinjam(String id) async {
    String urlDeletePinjam = "http://10.0.3.2/backend_eperpus/deletePinjam.php";
    try {
      var resDeletePinjam =
          await http.post(Uri.parse(urlDeletePinjam), body: {"id": id});
      var bodyDelete = json.decode(resDeletePinjam.body);
      if (bodyDelete['Success'] == "true") {
        if (kDebugMode) {
          print("Peminjaman Berhasil Dihapus ");
        }
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<dynamic> calculateDenda(String peminjamanId) async {
    String urlCalculateDenda =
        "http://10.0.3.2/backend_eperpus/addKembali.php";
    try {
      var response = await http.post(Uri.parse(urlCalculateDenda),
          body: {"peminjaman_id": peminjamanId});
      var body = json.decode(response.body);
      if (body['Success'] == true) {
        return body['Denda'];
      } else {
        return 0;
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
      return 0;
    }
  }

  Future<void> returnPinjam(String peminjamanId, int originalIndex) async {
    var denda = await calculateDenda(peminjamanId);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Denda"),
          content: Text("Denda yang harus dibayarkan: Rp $denda"),
          actions: [
            TextButton(
              onPressed: () async {
                String urlReturnPinjam =
                    "http://10.0.3.2/backend_eperpus/addKembali.php";
                var response = await http.post(Uri.parse(urlReturnPinjam),
                    body: {"peminjaman_id": peminjamanId});
                var body = json.decode(response.body);
                if (body['Success'] == true) {
                  setState(() {
                    listPinjam[originalIndex]['isReturned'] =
                        true; // Update status
                  });
                  if (kDebugMode) {
                    print("Pengembalian Berhasil");
                  }
                } else {
                  if (kDebugMode) {
                    print("Pengembalian Gagal");
                  }
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStokBuku(String peminjamanId) async {
    String urlUpdateStok = "http://10.0.3.2/backend_eperpus/updateStokBuku.php";
    try {
      var response = await http
          .post(Uri.parse(urlUpdateStok), body: {"buku_id": peminjamanId});
      var body = json.decode(response.body);
      if (body['Success'] == true) {
        if (kDebugMode) {
          print("Stok buku berhasil diperbarui");
        }
      } else {
        if (kDebugMode) {
          print("Gagal memperbarui stok buku");
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
        // leading: const Icon(
        //   Icons.menu,
        //   size: 20,
        //   color: Colors.white,
        // ),
        title: const Text(
          "DAFTAR PEMINJAM",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(3, 10, 3, 0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari Peminjam",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchPinjam();
                  },
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 206, 233, 255),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount:
                    listPinjam.where((item) => !item['isReturned']).length,
                itemBuilder: (context, filteredIndex) {
                  var filteredList =
                      listPinjam.where((item) => !item['isReturned']).toList();
                  var originalIndex =
                      listPinjam.indexOf(filteredList[filteredIndex]);

                  return Card(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      title: Text(
                        filteredList[filteredIndex]['judul_buku'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Peminjam: ${filteredList[filteredIndex]['nama_peminjam']}'),
                          Text(
                              'Kode Buku: ${filteredList[filteredIndex]['kode_buku']}'),
                          Text(
                              'Tgl Pinjam: ${filteredList[filteredIndex]['tanggal_peminjaman']}'),
                          Text(
                              'Batas Kembali: ${filteredList[filteredIndex]['batas_pengembalian']}'),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              returnPinjam(
                                  filteredList[filteredIndex]['id'].toString(),
                                  originalIndex);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 63, 114, 241),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Kembalikan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              deletePinjam(
                                  filteredList[filteredIndex]['id'].toString());
                              getAllPinjam();
                            },
                            child: const Icon(
                              CupertinoIcons.delete_solid,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const AddNewPinjam()));
        },
        mini: true,
        splashColor: const Color.fromARGB(255, 194, 255, 172),
        backgroundColor: const Color.fromARGB(255, 63, 197, 1),
        child: const Icon(
          Icons.add,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
