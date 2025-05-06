import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/detail_page.dart';
import 'package:project_house/ui/pages/home_page.dart';
import 'package:project_house/ui/pages/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> names = ['Jakarta Barat', 'Jawa Barat', 'Bandung'];

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
      body: Column(
        children: [
          const SizedBox(height: 60),
          SearchAnchor.bar(
            suggestionsBuilder:
                (context, controller) => names
                    .where(
                      (e) =>
                          controller.text.isEmpty ||
                          e.toLowerCase().contains(
                            controller.text.toLowerCase(),
                          ),
                    )
                    .map((e) => ListTile(title: Text(e))),
          ),
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
                  MaterialPageRoute(builder: (context) => DetailPage()),
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
