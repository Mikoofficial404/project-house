import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/detail_page.dart';
import 'package:project_house/ui/pages/home_page.dart';
import 'package:project_house/ui/pages/profile_page.dart';
import 'package:project_house/models/kosan.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final List<String> category = [
    'Living Room',
    'Bed Room',
    'Dining Room',
    'Kitchen',
    'Shower',
    'Garage',
    'Parking ',
  ];

  int _selectedIndex = 1;

  List<dynamic> menuItems = [
    {'icon': 'assets/images/home.svg', 'label': 'Home'},
    {'icon': 'assets/images/search.svg', 'label': 'Explore'},
    {'icon': 'assets/images/user.svg', 'label': 'User'},
  ];

  final List<Widget> _pages = [HomePage(), SearchPage(), ProfilePage()];
  
  // Create a sample Kosan object for demonstration
  final Kosan sampleKosan = Kosan(
    id: 'sample-1',
    imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXBhcnRtZW50fGVufDB8fDB8fHww&w=1000&q=80',
    deskripsi: 'Modern Apartment in Jakarta\nLuxury living in the heart of the city',
    lokasi: 'Jln. Ahmad Yani No.1, Jakarta, Indonesia',
    harga: 5000000,
    fasilitas: ['Living Room', 'Bed Room', 'Kitchen', 'WiFi', 'AC'],
    bedrooms: 2,
    bathrooms: 2,
    kitchens: 1,
    latitude: -6.200000,
    longitude: 106.816666,
  );

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Feature Suggestion',
                  style: blackTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 4, left: 12),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade500),
                  ),
                  child: Text(
                    category[index],
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: black,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Also Book',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailPage(kosan: sampleKosan)),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(padding: EdgeInsets.all(7)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/carsoul_images1.jpg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Furnished Home',
                          style: blackTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 4),
                            Text(
                              ' Jalan Setia Warga 1',
                              style: blackTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: light,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.bed, size: 20),
                            SizedBox(width: 4),
                            Text('3'),
                            SizedBox(width: 20),
                            Icon(Icons.bathtub, size: 20),
                            SizedBox(width: 4),
                            Text('2'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(children: [Text('Rp. 20000/Bulan')]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    );
  }
}
