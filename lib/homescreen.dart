import 'dart:async';
import 'dart:convert';

import 'package:eperpus_sakinah/gridanak.dart';
import 'package:eperpus_sakinah/gridfiksi.dart';
import 'package:eperpus_sakinah/gridkhusus.dart';
import 'package:eperpus_sakinah/gridnonfiksi.dart';
// import 'package:eperpus_sakinah/onboardingscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  PageController bannerController = PageController();
  Timer? timer;
  int indexBanner = 0;
  List listBuku = [];

  Future<void> getAllBuku() async {
    String urlAllProduct = "http://10.0.3.2/backend_eperpus/listBuku.php";
    try {
      var response = await http.get(Uri.parse(urlAllProduct));
      listBuku = jsonDecode(response.body);
      setState(() {
        listBuku = jsonDecode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  Future<void> searchProduct() async {
    String urlSearchProduct =
        "http://10.0.3.2/backend_eperpus/searchBuku.php?query=${searchController.text}";
    try {
      var responseSearch = await http.get(Uri.parse(urlSearchProduct));
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

  @override
  void initState() {
    super.initState();
    bannerController.addListener(() {
      setState(() {
        indexBanner = bannerController.page?.round() ?? 0;
      });
    });
    onboardBanner();
    getAllBuku();
  }

  void onboardBanner() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (indexBanner < 3) {
        indexBanner++;
      } else {
        indexBanner = 0;
      }
      bannerController.animateToPage(indexBanner,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bannerList = [
      './lib/assets/7.png',
      './lib/assets/6.jpg',
      './lib/assets/8.png',
      './lib/assets/9.png',
      './lib/assets/5.jpg',
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 98, 254),
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (BuildContext context) => const OnboardingScreen()));
        //   },
        // ),
        title: const Text(
          "BERANDA",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari Buku",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchProduct();
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
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: bannerController,
                itemCount: bannerList.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    bannerList[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GridFiksi()));
                        },
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('./lib/assets/fiksi.png',
                                  width: 40, height: 40, fit: BoxFit.cover),
                              const SizedBox(height: 5),
                              const Text(
                                'Fiksi',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GridNonFiksi()));
                        },
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('./lib/assets/nonfiksi.png',
                                  width: 40, height: 40, fit: BoxFit.cover),
                              const SizedBox(height: 5),
                              const Text(
                                'Non Fiksi',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GridAnak()));
                        },
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('./lib/assets/anak.png',
                                  width: 40, height: 40, fit: BoxFit.cover),
                              const SizedBox(height: 5),
                              const Text(
                                'Anak anak & Remaja',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                    textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const GridKhusus()));
                        },
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('./lib/assets/khusus.png',
                                  width: 40, height: 40, fit: BoxFit.cover),
                              const SizedBox(height: 5),
                              const Text(
                                'Khusus',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "List Buku",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 600,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0),
                  itemCount: listBuku.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listBuku[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              item['gambar'],
                              height: 100,
                              width: 120,
                              // fit: BoxFit.fill,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  "Error Loading Product Images",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 12),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                              child: Text(
                                item['judul'],
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                              child: Text(
                                    item['penulis'],
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
