import 'dart:convert';
import 'package:eperpus_sakinah/addbuku.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListBuku extends StatefulWidget {
  const ListBuku({super.key});

  @override
  State<ListBuku> createState() => _ListBukuState();
}

class _ListBukuState extends State<ListBuku> {
  @override
  void initState() {
    super.initState();
    getAllBuku();
  }

  final TextEditingController searchController = TextEditingController();
  List listBuku = [];

  Future<void> getAllBuku() async {
    String urlListBuku = "http://10.0.3.2/backend_eperpus/listBuku.php";
    var response = await http.get(Uri.parse(urlListBuku));
    try {
      setState(() {
        listBuku = jsonDecode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> searchBuku() async {
    String urlSearchBuku =
        "http://10.0.3.2/backend_eperpus/searchBuku.php?query=${searchController.text}";
    try {
      var responseSearch = await http.get(Uri.parse(urlSearchBuku));
      final List bodySearch = json.decode(responseSearch.body);
      setState(() {
        listBuku = bodySearch;
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> deleteBuku(String id) async {
    String urlDeleteBuku = "http://10.0.3.2/backend_eperpus/deleteBuku.php";
    try {
      var resDeleteBuku =
          await http.post(Uri.parse(urlDeleteBuku), body: {"id": id});
      var bodyDelete = json.decode(resDeleteBuku.body);
      if (bodyDelete['Success'] == "true") {
        if (kDebugMode) {
          print("Buku Berhasil Dihapus ");
        }
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  void onItemTap(int index) {
    final item = listBuku[index];
    if (kDebugMode) {
      print("Product Name ${item['name']}");
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailBuku(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        title: const Text(
          "DAFTAR BUKU",
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
                hintText: "Cari Buku",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchBuku();
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
            const SizedBox(height:8),
            Expanded(
              child: ListView.builder(
                itemCount: listBuku.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      onTap: () => onItemTap(index),
                      leading: ClipRRect(
                        child: Image.network(
                          height: 50.0,
                          width: 50.0,
                          '${listBuku[index]['gambar']}',
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                                "Kesalahan Memuat gambar dari server",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify);
                          },
                        ),
                      ),
                      title: Text(
                        listBuku[index]['judul'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${listBuku[index]['penulis']}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              listBuku[index]['deskripsi'],
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Kode Buku: '
                                  '${listBuku[index]['kode_buku']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Jumlah: ${listBuku[index]['jumlah']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      trailing: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              deleteBuku(listBuku[index]['id'].toString());
                              getAllBuku();
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
              builder: (BuildContext context) => const AddNewBuku()));
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

class DetailBuku extends StatelessWidget {
  final dynamic item;
  const DetailBuku({Key? key, required this.item}) : super(key: key);

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
          "DETAIL BUKU",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
            child: Image.network(
              item['gambar'],
              height: 400,
              width: 350,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text("Kesalahan Memuat gambar dari server ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              item['judul'],
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 20, 15),
            child: Text(
              item['deskripsi'],
              style: const TextStyle(
                  color: Color.fromARGB(199, 0, 0, 0),
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
            child: Text(
              item['penulis'],
              style: const TextStyle(
                  color: Color.fromARGB(198, 4, 87, 25),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
