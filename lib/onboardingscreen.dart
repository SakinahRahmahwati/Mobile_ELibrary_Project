import 'package:eperpus_sakinah/login.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController onboardingController = PageController();
  int indexPage = 0;
  List<Map<String, String>> onboardPageData = [
    {
      "title": "Perpustakaan Elektronik",
      "image":
          './lib/assets/1.png',
      "subtitle": "Selamat Datang di Perpustakaan Elektronik"
    },
    {
      "title": "Buku Terbaru",
      "image":
          './lib/assets/4.png',
      "subtitle": "Temukan judul terbaru dan tambah pengetahuan tanpa batas"
    },
    {
      "title": "Berbagai pilihan buku",
      "image":
          './lib/assets/2.png',
      "subtitle": "Jelajahi ribuan koleksi buku dalam genggaman Anda"
    },
    {
      "title": "Mulai",
      "image":
          './lib/assets/3.png',
      "subtitle": "Mulai jelajahi perpustakaan online"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: onboardingController,
              onPageChanged: (page) {
                setState(() {
                  indexPage = page;
                });
              },
              itemCount: onboardPageData.length,
              itemBuilder: (context, index) {
                return OnboardingData(
                  title: onboardPageData[index]['title']!,
                  image: onboardPageData[index]['image']!,
                  subtitle: onboardPageData[index]['subtitle']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                indexPage == onboardPageData.length - 1
                    ? TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text(
                          "Mulai",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))
                    : const Text(''),
                Row(
                  children: List.generate(
                    onboardPageData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indexPage == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    if (indexPage == onboardPageData.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      onboardingController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData extends StatelessWidget {
  final String title;
  final String image;
  final String subtitle;
  const OnboardingData(
      {super.key,
      required this.title,
      required this.image,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          // height: 350,
          // width: 300,
          fit: BoxFit.fill,
          // loadingBuilder: (context, child, loadingProgress) {
          //   if (loadingProgress == null) {
          //     return child;
          //   } else {
          //     return CircularProgressIndicator(
          //       value: loadingProgress.expectedTotalBytes != null
          //           ? loadingProgress.cumulativeBytesLoaded /
          //               (loadingProgress.expectedTotalBytes ?? 1)
          //           : null,
          //     );
          //   }
          // },
          // errorBuilder: (context, error, stackTrace) {
          //   return const Text("Kesalahan Memuat gambar dari server",
          //       style: TextStyle(
          //           fontSize: 18,
          //           color: Colors.red,
          //           fontWeight: FontWeight.bold),
          //       textAlign: TextAlign.justify);
          // },
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 17,
                color: Colors.grey,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
