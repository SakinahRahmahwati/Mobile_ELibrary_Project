import 'dart:convert';
import 'package:eperpus_sakinah/navigasi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GridNonFiksi extends StatefulWidget {
  const GridNonFiksi({super.key});

  @override
  State<GridNonFiksi> createState() => _GridNonFiksiState();
}

class _GridNonFiksiState extends State<GridNonFiksi> {
  List<dynamic> nonFiksiList = [];

  Future<void> getNonFiksi() async {
    String urlNonFiksi = 'http://10.0.3.2/backend_eperpus/kategoriNonFiksi.php';
    var response = await http.get(Uri.parse(urlNonFiksi));
    try {
      nonFiksiList = jsonDecode(response.body);
      setState(() {
        nonFiksiList = jsonDecode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  void onItemTap(int index) {
    final item = nonFiksiList[index];
    if (kDebugMode) {
      print("Judul Buku ${item['judul']}");
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailNonFiksi(item: item)));
  }

  @override
  void initState() {
    super.initState();
    getNonFiksi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const Navigasi()));
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.white,
            )),
        title: const Text(
          "Buku Non Fiksi",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.90,),
            itemCount: (nonFiksiList.length),
            itemBuilder: (context, index) {
              final data = nonFiksiList[index];
              return GestureDetector(
                onTap: () {
                  onItemTap(index);
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        data['gambar'],
                        height: 125,
                        width: 150,
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
                          return const Text(
                            "Kesalahan Memuat gambar dari server",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                        child: Text(
                          data['judul'],
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          data['penulis'],
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 160, 158, 180),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class DetailNonFiksi extends StatelessWidget {
  final dynamic item;
  const DetailNonFiksi({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const GridNonFiksi()));
          },
        ),
        title: const Text(
          "Detail Buku",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                return const Text("Kesalahan Memuat gambar dari server",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 20, 15),
            child: Text(
              item['judul'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Deskripsi Buku",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
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
