import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  List<DocumentSnapshot> _allResults = [];
  List<Kosan> _resultList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    List<Kosan> showResults = [];
    if (_searchController.text != '') {
      for (var kosanSnapshot in _allResults) {
        var data = kosanSnapshot.data() as Map<String, dynamic>;
        var lokasi = data['lokasi'].toString().toLowerCase();
        var deskripsi = data['deskripsi'].toString().toLowerCase();
        
        if (lokasi.contains(_searchController.text.toLowerCase()) || 
            deskripsi.contains(_searchController.text.toLowerCase())) {
          showResults.add(Kosan.fromMap(data, kosanSnapshot.id));
        }
      }
    } else {
      showResults = _allResults.map((doc) => 
        Kosan.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    }
    
    setState(() {
      _resultList = showResults;
    });
  }

  getKosanStream() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      var data = await FirebaseFirestore.instance
          .collection('kosan')
          .orderBy('lokasi')
          .get();

      setState(() {
        _allResults = data.docs;
        _isLoading = false;
      });
      searchResultList();
    } catch (e) {
      print('Error fetching kosan data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getKosanStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(controller: _searchController),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Hasil Pencarian',
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
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator())
              : _resultList.isEmpty 
                ? Center(
                    child: Text(
                      'Kosan Tidak Ketemu ',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: (context, index) {
                        final kosan = _resultList[index];
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
                                    builder: (context) => DetailPage(kosan: kosan),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: kosan.imageUrl.isNotEmpty
                                      ? Image.network(
                                          kosan.imageUrl,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                style: blackTextStyle.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: light,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: kosan.isAvailable ? Colors.green : Colors.red,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            kosan.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
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
                                            children: kosan.fasilitas.take(2).map((facilityStr) {
                                              IconData icon;
                                              if (facilityStr.toString().toLowerCase().contains('living') || 
                                                  facilityStr.toString().toLowerCase().contains('ruang tamu')) {
                                                icon = Icons.weekend;
                                              } else if (facilityStr.toString().toLowerCase().contains('bed') || 
                                                       facilityStr.toString().toLowerCase().contains('kamar tidur') || 
                                                       facilityStr.toString().toLowerCase().contains('tidur')) {
                                                icon = Icons.bed;
                                              } else if (facilityStr.toString().toLowerCase().contains('dining') || 
                                                       facilityStr.toString().toLowerCase().contains('makan')) {
                                                icon = Icons.restaurant;
                                              } else if (facilityStr.toString().toLowerCase().contains('kitchen') || 
                                                       facilityStr.toString().toLowerCase().contains('dapur')) {
                                                icon = Icons.kitchen;
                                              } else if (facilityStr.toString().toLowerCase().contains('wifi') || 
                                                       facilityStr.toString().toLowerCase().contains('internet')) {
                                                icon = Icons.wifi;
                                              } else if (facilityStr.toString().toLowerCase().contains('ac') || 
                                                       facilityStr.toString().toLowerCase().contains('air')) {
                                                icon = Icons.ac_unit;
                                              } else {
                                                icon = Icons.home;
                                              }
                                              
                                              return Chip(
                                                avatar: Icon(icon, size: 20),
                                                label: Text(
                                                  facilityStr.toString(),
                                                  style: TextStyle(fontSize: 10),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      },
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
        items: menuItems.map((i) {
          return BottomNavigationBarItem(
            activeIcon: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: SvgPicture.asset(i['icon'], colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ),
            icon: SvgPicture.asset(i['icon'], colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
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