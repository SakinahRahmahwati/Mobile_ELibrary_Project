import 'dart:async';
import 'package:eperpus_sakinah/homescreen.dart';
import 'package:eperpus_sakinah/listbuku.dart';
import 'package:eperpus_sakinah/listpinjam.dart';
import 'package:flutter/material.dart';

class Navigasi extends StatefulWidget {
  const Navigasi({super.key});

  @override
  State<Navigasi> createState() => _NavigasiState();
}

class _NavigasiState extends State<Navigasi> {
  final TextEditingController searchController = TextEditingController();
  PageController bannerController = PageController();
  Timer? timer;
  int indexBanner = 0;
  List listBuku = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const ListBuku(),
      const ListPinjam(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: "Beranda",
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.book,
                label: "Buku",
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.list,
                label: "Peminjaman",
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: isSelected ? 28 : 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: isSelected ? 12 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
