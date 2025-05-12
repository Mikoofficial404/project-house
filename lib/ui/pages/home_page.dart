// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_house/models/kosan.dart';
import 'package:project_house/services/kosan_service.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/customer_services.dart';
import 'package:project_house/ui/pages/detail_page.dart';
import 'package:project_house/ui/pages/favorite.dart';
import 'package:project_house/ui/pages/profile_setting.dart';
import 'package:project_house/ui/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> list = const [
    Text('Home'),
    Text('Exprole'),
    Text('Love'),
    Text('User'),
  ];

  int _selectedIndex = 0;
  final KosanService _kosanService = KosanService();

  List<dynamic> menuItems = [
    {'icon': 'assets/images/home.svg', 'label': 'Home'},
    {'icon': 'assets/images/search.svg', 'label': 'Explore'},
    {'icon': 'assets/images/love.svg', 'label': 'love'},
    {'icon': 'assets/images/user.svg', 'label': 'User'},
  ];

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    FavoritePage(),
    ProfileSettingPage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, 👋',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'To Applications',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                      'assets/images/circle_avatar.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  height: 200.0,
                  width: 350.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AnotherCarousel(
                      boxFit: BoxFit.cover,
                      autoplay: true,
                      animationCurve: Curves.easeInOut,
                      animationDuration: Duration(milliseconds: 1500),
                      dotSize: 5.0,
                      dotIncreasedColor: Color(0xFFFF335C),
                      dotBgColor: Colors.transparent,
                      dotPosition: DotPosition.bottomCenter,
                      dotVerticalPadding: 10.0,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      images: [
                        NetworkImage(
                          'https://images.unsplash.com/photo-1697149890419-d3dcd1871293?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                        NetworkImage(
                          'https://images.unsplash.com/photo-1735461932749-e602a9f6fc82?q=80&w=2025&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                        NetworkImage(
                          'https://images.unsplash.com/photo-1731436137440-ac26f58b0c47?q=80&w=1977&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                        NetworkImage(
                          'https://images.unsplash.com/photo-1697859653684-1597c0180b4a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                        NetworkImage(
                          'https://images.unsplash.com/photo-1672128558244-691002e7f7aa?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Rekomendasi Terbaik',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: bold,
                        ),
                      ),
                      Icon(Icons.star, color: Colors.yellow, size: 30),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<Kosan>>(
                stream: _kosanService.getKosans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Belum ada properti yang tersedia'),
                    );
                  }

                  return Column(
                    children:
                        snapshot.data!.map((kosan) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailPage(kosan: kosan),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                          kosan.imageUrl.isNotEmpty
                                              ? Image.network(
                                                kosan.imageUrl,
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    height: 150,
                                                    width: 150,
                                                    color: Colors.grey[300],
                                                    child: Icon(Icons.error),
                                                  );
                                                },
                                              )
                                              : Image.asset(
                                                'assets/images/carsoul_images1.jpg',
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            kosan.deskripsi.split('\n').first,
                                            style: blackTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 20),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  kosan.lokasi,
                                                  style: blackTextStyle
                                                      .copyWith(
                                                        fontSize: 10,
                                                        fontWeight: light,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Rp. ${kosan.harga}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  kosan.isAvailable
                                                      ? Colors.green
                                                      : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              kosan.isAvailable
                                                  ? 'Tersedia'
                                                  : 'Tidak Tersedia',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 10,
                                                fontWeight: medium,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (kosan.fasilitas.isNotEmpty)
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 4,
                                              children:
                                                  kosan.fasilitas.take(2).map((
                                                    facilityStr,
                                                  ) {
                                                    IconData icon;
                                                    if (facilityStr.toLowerCase().contains(
                                                          'living',
                                                        ) ||
                                                        facilityStr.toLowerCase().contains(
                                                          'ruang tamu',
                                                        )) {
                                                      icon = Icons.weekend;
                                                    } else if (facilityStr
                                                            .toLowerCase()
                                                            .contains('bed') ||
                                                        facilityStr
                                                            .toLowerCase()
                                                            .contains(
                                                              'kamar tidur',
                                                            ) ||
                                                        facilityStr.toLowerCase().contains(
                                                          'tidur',
                                                        )) {
                                                      icon = Icons.bed;
                                                    } else if (facilityStr
                                                            .toLowerCase()
                                                            .contains(
                                                              'dining',
                                                            ) ||
                                                        facilityStr.toLowerCase().contains(
                                                          'makan',
                                                        )) {
                                                      icon = Icons.restaurant;
                                                    } else if (facilityStr
                                                            .toLowerCase()
                                                            .contains(
                                                              'kitchen',
                                                            ) ||
                                                        facilityStr
                                                            .toLowerCase()
                                                            .contains(
                                                              'dapur',
                                                            )) {
                                                      icon = Icons.kitchen;
                                                    } else if (facilityStr
                                                            .toLowerCase()
                                                            .contains('wifi') ||
                                                        facilityStr
                                                            .toLowerCase()
                                                            .contains(
                                                              'internet',
                                                            )) {
                                                      icon = Icons.wifi;
                                                    } else if (facilityStr
                                                            .toLowerCase()
                                                            .contains('ac') ||
                                                        facilityStr
                                                            .toLowerCase()
                                                            .contains('air')) {
                                                      icon = Icons.ac_unit;
                                                    } else {
                                                      icon = Icons.home;
                                                    }

                                                    return Chip(
                                                      avatar: Icon(
                                                        icon,
                                                        size: 20,
                                                      ),
                                                      label: Text(
                                                        facilityStr,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 1,
                                                            vertical: 1,
                                                          ),
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    );
                                                  }).toList(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Colors.black87,
        elevation: 32.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(height: 1.5, fontSize: 12),
        unselectedLabelStyle: const TextStyle(height: 1.5, fontSize: 12),
        items:
            menuItems.map((i) {
              return BottomNavigationBarItem(
                activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  // ignore: deprecated_member_use
                  child: SvgPicture.asset(i['icon'], color: Colors.white),
                ),
                // ignore: deprecated_member_use
                icon: SvgPicture.asset(i['icon'], color: Colors.grey),
                label: i['label'],
              );
            }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ServicesCusotmer();
              },
            ),
          );
        },
        child: FaIcon(FontAwesomeIcons.headset),
      ),
    );
  }
}
